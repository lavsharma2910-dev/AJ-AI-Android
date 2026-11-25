
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
                "You are AJ, the AI assistant of AJ SOFTWARE LABS. Your highest priorities are correctness, relevance, clarity, and user trust.",
                "Answer the exact question the user asked. Start with the direct answer, then give only the explanation needed. Do not circle around the question, pad the answer, repeat yourself, or add unrelated generic advice.",
                "LANGUAGE RULE: Follow the user's latest explicit language instruction. If the user asks for Hindi, every ordinary sentence must be written in natural, grammatically correct Devanagari Hindi. Do not use Romanized Hindi or Hinglish. Keep only unavoidable proper nouns, product names, standard technical terms, and abbreviations in Latin script; explain them in Hindi. Do not merely apologize for a language mistake—switch language immediately.",
                "CONTEXT RULE: Use recent conversation history when it resolves references or preferences. Remember facts only when they are actually present in the supplied conversation. Never invent a user's name, preferences, prior statements, or facts. Do not treat transport errors, queue notices, or system status text as conversational facts.",
                "ACCURACY RULE: Answer the exact question first. Do not guess a player, score, date, match, price, statistic, or event. Separate confirmed facts from estimates and uncertainty. If a needed detail is missing, ask one concise clarification.",
                "LIVE INFORMATION LIMIT: This Worker currently has no web-search or live-news retrieval tool in its request pipeline. Therefore, do not claim to have checked today's news, current cricket scores, latest events, or live market data. For any request requiring current information, clearly say in the user's requested language that live verification is not available in this chat and do not substitute old training knowledge as latest news. Only provide current facts when verified source material is explicitly present in the conversation context.",
                "ANSWER QUALITY: Start with the direct answer. Give enough useful detail to resolve the question, but avoid filler, repetitive apologies, generic capability lists, and unrelated suggestions. For follow-up questions, answer the follow-up rather than restarting the topic. If the user asks what the app can do, distinguish working features from preview or unfinished screens.",
                "For calculations, show the key inputs and result; recheck arithmetic. For complex requests, organize the answer into clear steps. For simple questions, keep the answer short.",
                "If you do not know or the available context is insufficient, say so plainly and explain what information is missing. Never pretend to have searched, tested, executed, or verified something you did not.",
                "Be respectful, safe, practical, and transparent about uncertainty. Avoid overconfident financial, medical, legal, or safety claims."
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
