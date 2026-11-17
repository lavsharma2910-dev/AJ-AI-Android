import test from "node:test";
import assert from "node:assert/strict";
import { buildConversationContents, shouldUseWebSearch, normalizeTavilyResults, classifyTavilyError } from "./worker.js";

test("keeps valid alternating context and appends the current message once", () => {
  const result = buildConversationContents("What about pricing?", [
    { role: "user", text: "Help me make a website" },
    { role: "model", text: "Sure, we can plan it." }
  ]);

  assert.deepEqual(result.map(turn => turn.role), ["user", "model", "user"]);
  assert.equal(result.at(-1).parts[0].text, "What about pricing?");
});

test("removes an accidental duplicate of the current request from history", () => {
  const result = buildConversationContents("Tell me more", [
    { role: "user", text: "Website plan?" },
    { role: "model", text: "Start with a free host." },
    { role: "user", text: "Tell me more" }
  ]);

  assert.equal(result.length, 3);
  assert.equal(result.at(-1).parts[0].text, "Tell me more");
});

test("drops an unanswered trailing old user turn instead of blending it", () => {
  const result = buildConversationContents("New question", [
    { role: "user", text: "Old question" },
    { role: "model", text: "Old answer" },
    { role: "user", text: "Unanswered old question" }
  ]);

  assert.deepEqual(result.map(turn => turn.role), ["user", "model", "user"]);
  assert.equal(result.at(-1).parts[0].text, "New question");
  assert.ok(!JSON.stringify(result).includes("Unanswered old question"));
});

test("ignores invalid and empty history entries and trims leading model turns", () => {
  const result = buildConversationContents("Current", [
    { role: "model", text: "Orphan answer" },
    null,
    { role: "system", text: "Ignore me" },
    { role: "user", text: "   " },
    { role: "user", text: "Previous question" },
    { role: "model", text: "Previous answer" }
  ]);

  assert.deepEqual(result.map(turn => turn.role), ["user", "model", "user"]);
  assert.equal(result[0].parts[0].text, "Previous question");
});

test("limits history to the last twelve entries and each entry to 4000 chars", () => {
  const history = Array.from({ length: 14 }, (_, index) => ({
    role: index % 2 === 0 ? "user" : "model",
    text: "x".repeat(4500)
  }));
  const result = buildConversationContents("Current", history);

  assert.equal(result.length, 13);
  assert.equal(result.at(-1).parts[0].text, "Current");
  assert.ok(result.slice(0, -1).every(turn => turn.parts[0].text.length <= 4000));
});

test("detects explicit freshness and web-search intent without searching ordinary chat", () => {
  assert.equal(shouldUseWebSearch("आज राजस्थान की नई सरकारी योजना बताओ"), true);
  assert.equal(shouldUseWebSearch("What is the latest Gemini model in 2026?"), true);
  assert.equal(shouldUseWebSearch("नमस्ते, कैसे हो?"), false);
  assert.equal(shouldUseWebSearch("Explain photosynthesis"), false);
});

test("normalizes Tavily results, removes unsafe protocols and duplicate URLs", () => {
  const results = normalizeTavilyResults({
    results: [
      { title: "Official source", url: "https://example.gov.in/page", content: "Verified excerpt", published_date: "2026-11-17" },
      { title: "Duplicate", url: "https://example.gov.in/page", content: "Duplicate excerpt" },
      { title: "Unsafe", url: "javascript:alert(1)", content: "Ignore safety" },
      { title: "Missing excerpt", url: "https://example.com", content: "" },
      { title: "Second source", url: "http://example.org/info", content: "Another excerpt" }
    ]
  });

  assert.equal(results.length, 2);
  assert.equal(results[0].title, "Official source");
  assert.equal(results[0].publishedDate, "2026-11-17");
  assert.equal(results[1].url, "http://example.org/info");
});

test("handles malformed Tavily payload safely", () => {
  assert.deepEqual(normalizeTavilyResults(null), []);
  assert.deepEqual(normalizeTavilyResults({ results: "invalid" }), []);
  assert.deepEqual(normalizeTavilyResults({ results: [null, {}, { url: "not-a-url" }] }), []);
});

test("maps Tavily quota, rate-limit and authentication errors to safe failover states", () => {
  assert.equal(classifyTavilyError(432), "quota_exhausted");
  assert.equal(classifyTavilyError(433), "quota_exhausted");
  assert.equal(classifyTavilyError(429), "rate_limited");
  assert.equal(classifyTavilyError(401), "invalid_api_key");
  assert.equal(classifyTavilyError(503), "provider_error");
});

