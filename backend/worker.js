
import { classifyKnowledgeNeed, buildKnowledgePolicyInstruction } from "./knowledge_policy.mjs";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
  "Content-Type": "application/json; charset=utf-8"
};

function response(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: corsHeaders
  });
}

const MODELS = [
  "gemini-3.8-flash",
  "gemini-3.5-flash-lite"
];

async function callGemini(model, contents, apiKey, policyInstruction) {
  const startedAt = Date.now();
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 25000);

  try {
    const apiResponse = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": apiKey
        },
        body: JSON.stringify({
          systemInstruction: {
            parts: [{
              text: [
                "You are AJ, the AI assistant of AJ SOFTWARE LABS. Your highest priorities are correctness, relevance, clarity, and user trust.",
                "Answer the exact question the user asked. Start with the direct answer, then give only the explanation needed. Do not circle around the question, pad the answer, repeat yourself, or add unrelated generic advice.",
                "Understand Hindi, Hinglish, and English. Match the user's language. If the user asks for Hindi, reply in natural, grammatically correct Devanagari Hindi; do not write Hindi in Latin letters unless the user explicitly requests Hinglish.",
                "Treat an explicit language or script preference as persistent conversation context: once the user asks for Hindi, continue replying in natural Devanagari Hindi on later turns, including short follow-ups such as yes, haan, or continue, until the user explicitly requests another language or script. Do not switch to English or Romanized Hindi merely because the user types Hinglish. Use common English technical terms only when they are clearer, and explain them briefly in Hindi when needed.",
                "Use the conversation history only when it is relevant. Do not invent personal details, facts, citations, statistics, dates, prices, market data, or events. Clearly distinguish verified facts from estimates, opinions, and assumptions.",
                "For time-sensitive or current facts, state when you cannot verify live information. Never present stale knowledge or a guess as current fact. If essential context is missing, ask one concise clarification instead of guessing.",
                "For calculations, show the key inputs and result; recheck arithmetic. For complex requests, organize the answer into clear steps. For simple questions, keep the answer short.",
                "If you do not know or the available context is insufficient, say so plainly and explain what information is missing. Never pretend to have searched, tested, executed, or verified something you did not.",
                "Be respectful, safe, practical, and transparent about uncertainty. Avoid overconfident financial, medical, legal, or safety claims.",
                policyInstruction
              ].filter(Boolean).join(" ")
            }]
          },
          contents,
          generationConfig: {
            maxOutputTokens: 2048
          }
        }),
        signal: controller.signal
      }
    );

    const result = await apiResponse.json().catch(() => ({}));

    if (!apiResponse.ok) {
      return {
        ok: false,
        status: apiResponse.status,
        durationMs: Date.now() - startedAt
      };
    }

    const answer = result.candidates?.[0]?.content?.parts
      ?.map(part => part.text || "")
      .join("")
      .trim();

    if (!answer) {
      return { ok: false, status: 502, durationMs: Date.now() - startedAt };
    }

    return {
      ok: true,
      answer,
      model,
      durationMs: Date.now() - startedAt
    };

  } catch (error) {
    return {
      ok: false,
      status: error.name === "AbortError" ? 408 : 503,
      durationMs: Date.now() - startedAt
    };
  } finally {
    clearTimeout(timeout);
  }
}

export default {
  async fetch(request, env) {
    const requestStartedAt = Date.now();
    const url = new URL(request.url);

    if (request.method === "OPTIONS") {
      return new Response(null, { headers: corsHeaders });
    }

    if (request.method === "GET" && url.pathname === "/") {
      return response({
        status: "online",
        service: "AJ AI Backend",
        fallback: "enabled"
      });
    }

    if (request.method !== "POST" || url.pathname !== "/chat") {
      return response({ error: "Not found" }, 404);
    }

    if (!env.GEMINI_API_KEY) {
      return response({
        error: "Gemini API key is not configured"
      }, 500);
    }

    let body;

    try {
      body = await request.json();
    } catch {
      return response({ error: "Invalid JSON request" }, 400);
    }

    const requestId = typeof body.requestId === "string" &&
        /^[a-f0-9]{32}$/i.test(body.requestId)
      ? body.requestId
      : crypto.randomUUID();

    const message = typeof body.message === "string"
      ? body.message.trim()
      : "";

    if (!message || message.length > 20000) {
      console.log(JSON.stringify({
        event: "chat_rejected",
        requestId,
        reason: "invalid_message",
        totalDurationMs: Date.now() - requestStartedAt
      }));
      return response({
        error: "Message is required (maximum 20000 characters)",
        requestId
      }, 400);
    }

    const knowledgeClassification = classifyKnowledgeNeed(message);
    const knowledgePolicy = buildKnowledgePolicyInstruction(knowledgeClassification);

    const history = Array.isArray(body.history)
      ? body.history.slice(-12)
          .filter(item =>
            item &&
            ["user", "model"].includes(item.role) &&
            typeof item.text === "string"
          )
          .map(item => ({
            role: item.role,
            parts: [{ text: item.text.slice(0, 4000) }]
          }))
      : [];

    const contents = [
      ...history,
      {
        role: "user",
        parts: [{ text: message }]
      }
    ];

    // Correlate timings without logging prompts, chat history, or credentials.
    console.log(JSON.stringify({
      event: "chat_start",
      requestId,
      historyCount: history.length,
      messageLength: message.length
    }));

    // Try primary model, then backup model.
    for (const model of MODELS) {
      const result = await callGemini(
        model,
        contents,
        env.GEMINI_API_KEY,
        knowledgePolicy
      );

      console.log(JSON.stringify({
        event: "gemini_attempt",
        requestId,
        model,
        success: result.ok,
        status: result.status || 200,
        durationMs: result.durationMs
      }));

      if (result.ok) {
        const totalDurationMs = Date.now() - requestStartedAt;
        const fallbackUsed = model !== MODELS[0];
        console.log(JSON.stringify({
          event: "chat_complete",
          requestId,
          model: result.model,
          totalDurationMs,
          fallbackUsed
        }));
        return response({
          reply: result.answer,
          model: result.model,
          fallbackUsed,
          requestId,
          serverDurationMs: totalDurationMs
        });
      }

      // Stop on client-side request errors.
      if (result.status >= 400 &&
          result.status < 500 &&
          result.status !== 408 &&
          result.status !== 429) {
        return response({
          error: "AI request could not be processed",
          status: result.status
        }, 502);
      }
    }

    const totalDurationMs = Date.now() - requestStartedAt;
    console.log(JSON.stringify({
      event: "chat_failed",
      requestId,
      totalDurationMs
    }));
    return response({
      error: "Both AI models are temporarily unavailable. Please try again shortly.",
      requestId,
      serverDurationMs: totalDurationMs,
      retryable: true
    }, 503);
  }
};
