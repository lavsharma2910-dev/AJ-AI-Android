const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type",
  "Content-Type": "application/json; charset=utf-8"
};

function response(data, status = 200) {
  return new Response(JSON.stringify(data), { status, headers: corsHeaders });
}

// Provider-neutral configuration: Gemini is a temporary prototype adapter.
// A self-hosted adapter can be added later without changing the Android API.
export const AI_PROVIDER = "gemini";
export const MODEL_FALLBACKS = ["gemini-3.8-flash", "gemini-3.5-flash-lite"];

export function buildConversationContents(message, rawHistory) {
  const historyItems = Array.isArray(rawHistory) ? rawHistory.slice(-12) : [];
  const history = [];
  for (const item of historyItems) {
    if (!item || !["user", "model"].includes(item.role) || typeof item.text !== "string") continue;
    const value = item.text.trim().slice(0, 4000);
    if (!value) continue;
    const previous = history[history.length - 1];
    if (previous && previous.role === item.role) {
      previous.parts[0].text = (previous.parts[0].text + "\n\n" + value).slice(-8000);
    } else {
      history.push({ role: item.role, parts: [{ text: value }] });
    }
  }
  if (history.at(-1)?.role === "user") history.pop();
  const firstUser = history.findIndex(turn => turn.role === "user");
  if (firstUser < 0) history.length = 0;
  else history.splice(0, firstUser);
  history.push({ role: "user", parts: [{ text: message }] });
  return history;
}

const SYSTEM_INSTRUCTIONS = [
  "You are AJ, a helpful personal AI companion.",
  "Follow the language and script explicitly requested in the latest user message. If Hindi is requested, use natural Devanagari Hindi. If Roman Hindi is used without a script request, natural Hinglish is acceptable.",
  "Treat conversation history only as context. Do not replay it unless the user explicitly asks for a transcript or summary.",
  "Answer the latest message directly. Do not repeat greetings or introductions.",
  "Never claim persistent memory unless trusted memory is explicitly supplied.",
  "Be concise, practical, honest and beginner-friendly.",
  "Never invent completed actions, test results, live research or access to external accounts."
].join(" ");

export function getProviderConfig(env) {
  const provider = typeof env.AI_PROVIDER === "string" ? env.AI_PROVIDER : AI_PROVIDER;
  if (provider !== "gemini") return { ok: false, reason: "provider_not_enabled" };
  if (!env.GEMINI_API_KEY) return { ok: false, reason: "missing_provider_key" };
  return { ok: true, provider, models: MODEL_FALLBACKS, apiKey: env.GEMINI_API_KEY };
}

async function callGemini(model, contents, apiKey) {
  const startedAt = Date.now();
  const controller = new AbortController();
  const timeout = setTimeout(() => controller.abort(), 25000);
  try {
    const apiResponse = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json", "x-goog-api-key": apiKey },
        body: JSON.stringify({
          systemInstruction: { parts: [{ text: SYSTEM_INSTRUCTIONS }] },
          contents,
          generationConfig: { maxOutputTokens: 2048 }
        }),
        signal: controller.signal
      }
    );
    const result = await apiResponse.json().catch(() => ({}));
    if (!apiResponse.ok) {
      return { ok: false, status: apiResponse.status, durationMs: Date.now() - startedAt };
    }
    const answer = result.candidates?.[0]?.content?.parts?.map(part => part.text || "").join("").trim();
    if (!answer) return { ok: false, status: 502, durationMs: Date.now() - startedAt };
    return { ok: true, answer, model, provider: "gemini", durationMs: Date.now() - startedAt };
  } catch (error) {
    return {
      ok: false,
      status: error?.name === "AbortError" ? 408 : 503,
      durationMs: Date.now() - startedAt
    };
  } finally {
    clearTimeout(timeout);
  }
}

// One adapter entry point is the seam for a future AJ-owned inference server.
export async function callAiProvider(provider, model, contents, apiKey) {
  if (provider === "gemini") return callGemini(model, contents, apiKey);
  return { ok: false, status: 501, reason: "provider_not_implemented" };
}

export default {
  async fetch(request, env) {
    const requestStartedAt = Date.now();
    const url = new URL(request.url);
    if (request.method === "OPTIONS") return new Response(null, { headers: corsHeaders });
    if (request.method === "GET" && url.pathname === "/") {
      return response({
        status: "online",
        service: "AJ AI Backend",
        aiProviderMode: "temporary-prototype",
        provider: AI_PROVIDER,
        selfHostedAi: "planned",
        externalWebSearch: "disabled"
      });
    }
    if (request.method !== "POST" || url.pathname !== "/chat") {
      return response({ error: "Not found" }, 404);
    }

    const providerConfig = getProviderConfig(env);
    if (!providerConfig.ok) {
      return response({
        error: providerConfig.reason === "missing_provider_key"
          ? "Gemini API key is not configured"
          : "Configured AI provider is not enabled",
        code: providerConfig.reason
      }, 503);
    }

    let body;
    try { body = await request.json(); }
    catch { return response({ error: "Invalid JSON request" }, 400); }

    const message = typeof body.message === "string" ? body.message.trim() : "";
    if (!message || message.length > 6000) {
      return response({ error: "Message is required (maximum 6000 characters)" }, 400);
    }

    const contents = buildConversationContents(message, body.history);
    for (const model of providerConfig.models) {
      const result = await callAiProvider(providerConfig.provider, model, contents, providerConfig.apiKey);
      console.log(JSON.stringify({
        event: "ai_provider_attempt",
        provider: providerConfig.provider,
        model,
        success: result.ok,
        status: result.status || 200,
        durationMs: result.durationMs
      }));
      if (result.ok) {
        console.log(JSON.stringify({
          event: "chat_complete",
          provider: result.provider,
          totalDurationMs: Date.now() - requestStartedAt,
          modelFallbackUsed: model !== providerConfig.models[0]
        }));
        return response({
          reply: result.answer,
          provider: result.provider,
          model: result.model,
          modelFallbackUsed: model !== providerConfig.models[0],
          webSearchStatus: "disabled_privacy_first"
        });
      }
      if (result.status >= 400 && result.status < 500 &&
          result.status !== 408 && result.status !== 429) {
        return response({ error: "AI request could not be processed", status: result.status }, 502);
      }
    }
    console.log(JSON.stringify({ event: "chat_failed", totalDurationMs: Date.now() - requestStartedAt }));
    return response({ error: "AI models are temporarily unavailable. Please try again shortly." }, 503);
  }
};
