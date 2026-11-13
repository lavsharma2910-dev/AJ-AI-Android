
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

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (request.method === "OPTIONS") {
      return new Response(null, { headers: corsHeaders });
    }

    if (request.method === "GET" && url.pathname === "/") {
      return response({
        status: "online",
        service: "AJ AI Backend"
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

    try {
      const body = await request.json();
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

      const apiResponse = await fetch(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.8-flash:generateContent",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            "x-goog-api-key": env.GEMINI_API_KEY
          },
          body: JSON.stringify({
            systemInstruction: {
              parts: [{
                text: "You are AJ, a friendly and helpful AI companion. Understand Hindi, Hinglish and English. Reply naturally in the user's language. Be honest, safe and practical."
              }]
            },
            contents,
            generationConfig: {
              maxOutputTokens: 2048
            }
          })
        }
      );

      const result = await apiResponse.json();

      if (!apiResponse.ok) {
        return response({
          error: "Gemini API request failed",
          details: result.error?.message || "Unknown API error"
        }, 502);
      }

      const answer = result.candidates?.[0]?.content?.parts
        ?.map(part => part.text || "")
        .join("")
        .trim();

      if (!answer) {
        return response({
          error: "AI returned an empty response"
        }, 502);
      }

      return response({
        reply: answer,
        model: "gemini-3.8-flash"
      });

    } catch (error) {
      return response({
        error: "Backend request failed",
        details: error.message
      }, 500);
    }
  }
};
