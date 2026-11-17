import test from "node:test";
import assert from "node:assert/strict";
import {
  buildConversationContents,
  getProviderConfig,
  callAiProvider,
  AI_PROVIDER,
  MODEL_FALLBACKS
} from "./worker.js";

test("keeps valid alternating context and appends the current message once", () => {
  const result = buildConversationContents("What about pricing?", [
    { role: "user", text: "Help me make a website" },
    { role: "model", text: "Sure, we can plan it." }
  ]);
  assert.deepEqual(result.map(turn => turn.role), ["user", "model", "user"]);
  assert.equal(result.at(-1).parts[0].text, "What about pricing?");
});

test("removes an unanswered trailing old user turn", () => {
  const result = buildConversationContents("New question", [
    { role: "user", text: "Old question" },
    { role: "model", text: "Old answer" },
    { role: "user", text: "Unanswered old question" }
  ]);
  assert.deepEqual(result.map(turn => turn.role), ["user", "model", "user"]);
  assert.ok(!JSON.stringify(result).includes("Unanswered old question"));
});

test("ignores invalid entries and trims leading model turns", () => {
  const result = buildConversationContents("Current", [
    { role: "model", text: "Orphan answer" },
    null,
    { role: "system", text: "Ignore me" },
    { role: "user", text: "Previous question" },
    { role: "model", text: "Previous answer" }
  ]);
  assert.deepEqual(result.map(turn => turn.role), ["user", "model", "user"]);
  assert.equal(result[0].parts[0].text, "Previous question");
});

test("limits history length and entry size", () => {
  const history = Array.from({ length: 14 }, (_, index) => ({
    role: index % 2 === 0 ? "user" : "model",
    text: "x".repeat(4500)
  }));
  const result = buildConversationContents("Current", history);
  assert.equal(result.length, 13);
  assert.ok(result.slice(0, -1).every(turn => turn.parts[0].text.length <= 4000));
});

test("selects only the temporary Gemini prototype provider", () => {
  assert.equal(AI_PROVIDER, "gemini");
  assert.deepEqual(MODEL_FALLBACKS, ["gemini-3.8-flash", "gemini-3.5-flash-lite"]);
  assert.equal(getProviderConfig({ GEMINI_API_KEY: "test-key" }).ok, true);
  assert.equal(getProviderConfig({}).reason, "missing_provider_key");
  assert.equal(getProviderConfig({ AI_PROVIDER: "external-search", GEMINI_API_KEY: "x" }).reason, "provider_not_enabled");
});

test("does not silently enable an unimplemented provider adapter", async () => {
  const result = await callAiProvider("self-hosted", "local-model", [], "unused");
  assert.equal(result.ok, false);
  assert.equal(result.status, 501);
});
