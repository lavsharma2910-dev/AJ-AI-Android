
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

// Build a valid Gemini turn sequence and include the current message once.
export function buildConversationContents(message, rawHistory) {
  const historyItems = Array.isArray(rawHistory)
    ? rawHistory.slice(-12)
    : [];

  const history = [];
  for (const item of historyItems) {
    if (!item ||
        !["user", "model"].includes(item.role) ||
        typeof item.text !== "string") {
      continue;
    }

    const text = item.text.trim().slice(0, 4000);
    if (!text) continue;

    const previous = history[history.length - 1];
    if (previous && previous.role === item.role) {
      previous.parts[0].text = (
        previous.parts[0].text + "\n\n" + text
      ).slice(-8000);
    } else {
      history.push({
        role: item.role,
        parts: [{ text }]
      });
    }
  }

  // A trailing user turn is either an accidental copy of this request or an
  // unanswered old request. Drop it; never blend it into the new question.
  const lastTurn = history[history.length - 1];
  if (lastTurn && lastTurn.role === "user") {
    history.pop();
  }

  history.splice(0, history.findIndex(turn => turn.role === "user") < 0
    ? history.length
    : history.findIndex(turn => turn.role === "user"));

  history.push({
    role: "user",
    parts: [{ text: message }]
  });

  return history;
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
        headers: {
          "Content-Type": "application/json",
          "x-goog-api-key": apiKey
        },
        body: JSON.stringify({
          systemInstruction: {
            parts: [{
              text: [
                "You are AJ, a helpful personal AI companion.",
                "Follow the language and script explicitly requested in the latest user message. If the user says Hindi, reply in natural Hindi using Devanagari script; if the user writes Roman Hindi without requesting a script, natural Hinglish is acceptable. Use English when requested or clearly preferred.",
                "Treat the conversation history only as context. NEVER copy, quote, list, or replay the previous conversation unless the user explicitly asks for a transcript or summary.",
                "Answer only the user's latest message directly. Do not answer an earlier question again when a newer question is being asked.",
                "Do not repeat your greeting, introduction, or request for the user's name in every reply. Ask for a missing detail only when it is necessary.",
                "Do not claim to remember a name, preference, event, or personal fact unless it is present in the supplied conversation or trusted memory context.",
                "If the user asks whether you remember something and it is not in the available context, say honestly that it is not available. Do not imply that temporary chat context is permanent memory.",
                "Use earlier messages to resolve references, but mention only the relevant detail; do not dump the history.",
                "Default to concise, practical answers. Give detail only when the user asks for it or the task genuinely needs it. Avoid repeating the same point in different words.",
                "When the user asks for a website, app, or other code but has not specified its purpose or type, ask one short clarifying question before generating a large solution. If they explicitly ask for a simple example, provide a clearly labelled starter example.",
                "When generating code, state the file name and where it goes, provide complete runnable code when requested, and do not claim it was tested unless it actually was.",
                "When the user asks for step-by-step help, give one clear step at a time and use beginner-friendly explanations.",
                "Never invent completed actions, test results, persistent memory, or access to external accounts."
              ].join(" ")
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

    const message = typeof body.message === "string"
      ? body.message.trim()
      : "";

    if (!message || message.length > 6000) {
      return response({
        error: "Message is required (maximum 6000 characters)"
      }, 400);
    }

    const contents = buildConversationContents(message, body.history);

    // Try primary model, then backup model.
    for (const model of MODELS) {
      const result = await callGemini(
        model,
        contents,
        env.GEMINI_API_KEY
      );

      console.log(JSON.stringify({
        event: "gemini_attempt",
        model,
        success: result.ok,
        status: result.status || 200,
        durationMs: result.durationMs
      }));

      if (result.ok) {
        console.log(JSON.stringify({
          event: "chat_complete",
          totalDurationMs: Date.now() - requestStartedAt,
          fallbackUsed: model !== MODELS[0]
        }));
        return response({
          reply: result.answer,
          model: result.model,
          fallbackUsed: model !== MODELS[0]
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

    console.log(JSON.stringify({ event: "chat_failed", totalDurationMs: Date.now() - requestStartedAt }));
    return response({
      error: "Both AI models are temporarily unavailable. Please try again shortly."
    }, 503);
  }
};
