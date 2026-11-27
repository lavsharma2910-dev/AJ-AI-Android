// Deterministic request-level guardrails for knowledge freshness and high-impact topics.
// This module does not perform research or independently verify Gemini output.
const FRESHNESS_PATTERN =
  /\b(today|tonight|yesterday|latest|current|currently|right now|as of now|recent|this week|this month|this year|20\d{2})\b|आज|अभी|वर्तमान|ताज़ा|ताजा|नवीनतम|इस सप्ताह|इस महीने|इस साल|फिलहाल|आजकल/iu;

const HIGH_IMPACT_PATTERN =
  /\b(legal|law|lawsuit|court|police|copyright|trademark|patent|licen[cs]e|contract|tax|gst|income tax|loan|investment|invest|stock|share market|crypto|insurance|interest rate|earning|earnings|income|revenue|profit|monetization|monetize|commission|payout|royalty|commercial use|medical|medicine|medication|diagnosis|symptom|dosage|dose|treatment|emergency|safety|chemical|pesticide)\b|कानून|कानूनी|अदालत|पुलिस|कॉपीराइट|ट्रेडमार्क|पेटेंट|लाइसेंस|अनुबंध|टैक्स|कर|जीएसटी|लोन|कर्ज|निवेश|शेयर|क्रिप्टो|बीमा|ब्याज|कमाई|आय|मुनाफा|राजस्व|कमीशन|रॉयल्टी|भुगतान|चिकित्सा|दवा|इलाज|खुराक|लक्षण|निदान|आपातकाल|सुरक्षा|रसायन|कीटनाशक/iu;

export function classifyKnowledgeNeed(message) {
  const text = typeof message === "string" ? message : "";
  return {
    requiresFreshVerification: FRESHNESS_PATTERN.test(text),
    highImpact: HIGH_IMPACT_PATTERN.test(text)
  };
}

export function buildKnowledgePolicyInstruction(classification) {
  const instructions = [
    "Knowledge safety policy: never invent facts, sources, citations, dates, prices, legal provisions, statistics, earnings, or guarantees.",
    "Do not describe model memory as a live search, source check, test, or independent verification.",
    "If evidence is missing, distinguish established background from estimates and unknowns; state the limitation plainly."
  ];

  if (classification?.requiresFreshVerification) {
    instructions.push(
      "Freshness guard: this request appears to depend on current or time-sensitive information, but no live research results or source documents are attached. Do not claim the latest status is verified. State that current verification is unavailable in this request, give only stable background if useful, and identify the official source or evidence needed."
    );
  }

  if (classification?.highImpact) {
    instructions.push(
      "High-impact guard: this request may involve legal, financial, medical, or safety consequences. Give general information, not a definitive personalized professional judgment. Do not invent jurisdiction-specific rules or numerical outcomes. State material assumptions, ask one essential clarification when needed, and recommend checking the relevant official source or qualified professional before consequential action."
    );
  }

  return instructions.join(" ");
}
