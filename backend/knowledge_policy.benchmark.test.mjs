import test from "node:test";
import assert from "node:assert/strict";
import {
  classifyKnowledgeNeed,
  buildKnowledgePolicyInstruction
} from "./knowledge_policy.mjs";

const expected = (message, requiresFreshVerification, highImpact) => {
  assert.deepEqual(classifyKnowledgeNeed(message), {
    requiresFreshVerification,
    highImpact
  });
};

test("English latest/current terms require freshness verification", () => {
  for (const term of ["today", "latest", "current", "currently", "right now", "recent", "this week", "this month", "this year", "2026"]) {
    expected(`What is the ${term} update?`, true, false);
  }
});

test("Hindi freshness terms require verification", () => {
  for (const term of ["आज", "अभी", "वर्तमान", "ताज़ा", "ताजा", "नवीनतम", "इस सप्ताह", "इस महीने", "इस साल", "फिलहाल", "आजकल"]) {
    expected(`${term} सरकारी जानकारी बताइए`, true, false);
  }
});

test("English legal and intellectual-property topics are high impact", () => {
  for (const term of ["legal", "law", "lawsuit", "court", "police", "copyright", "trademark", "patent", "license", "licence", "contract"]) {
    expected(`Explain the ${term} requirements`, false, true);
  }
});

test("Hindi legal and intellectual-property topics are high impact", () => {
  for (const term of ["कानून", "कानूनी", "अदालत", "पुलिस", "कॉपीराइट", "ट्रेडमार्क", "पेटेंट", "लाइसेंस", "अनुबंध"]) {
    expected(`${term} के बारे में बताइए`, false, true);
  }
});

test("English financial topics are high impact", () => {
  for (const term of ["tax", "GST", "income tax", "loan", "investment", "invest", "stock", "share market", "crypto", "insurance", "interest rate", "income", "revenue", "profit", "commission", "payout", "royalty"]) {
    expected(`Explain ${term} rules`, false, true);
  }
});

test("Hindi financial topics are high impact", () => {
  for (const term of ["टैक्स", "कर", "जीएसटी", "लोन", "कर्ज", "निवेश", "शेयर", "क्रिप्टो", "बीमा", "ब्याज", "कमाई", "आय", "मुनाफा", "राजस्व", "कमीशन", "रॉयल्टी", "भुगतान"]) {
    expected(`${term} की जानकारी दें`, false, true);
  }
});

test("English medical and safety topics are high impact", () => {
  for (const term of ["medical", "medicine", "medication", "diagnosis", "symptom", "dosage", "dose", "treatment", "emergency", "safety", "chemical", "pesticide"]) {
    expected(`Question about ${term}`, false, true);
  }
});

test("Hindi medical and safety topics are high impact", () => {
  for (const term of ["चिकित्सा", "दवा", "इलाज", "खुराक", "लक्षण", "निदान", "आपातकाल", "सुरक्षा", "रसायन", "कीटनाशक"]) {
    expected(`${term} की जानकारी दें`, false, true);
  }
});

test("freshness and high-impact flags can both be true", () => {
  expected("What are the latest GST rules in 2026?", true, true);
  expected("आज के वर्तमान कानूनी नियम क्या हैं?", true, true);
});

test("stable general education question is not flagged", () => {
  expected("Explain how photosynthesis works.", false, false);
});

test("stable programming question is not flagged", () => {
  expected("Explain variables and functions in JavaScript.", false, false);
});

test("ordinary creative writing request is not flagged", () => {
  expected("Write a short story about a village.", false, false);
});

test("ordinary arithmetic request is not flagged", () => {
  expected("What is 25 multiplied by 4?", false, false);
});

test("ordinary translation request is not flagged", () => {
  expected("Translate hello into Hindi.", false, false);
});

test("empty string is handled deterministically", () => {
  expected("", false, false);
});

test("non-string input is treated as empty text", () => {
  expected(null, false, false);
  expected(undefined, false, false);
  expected(12345, false, false);
  expected({ message: "latest loan" }, false, false);
});

test("freshness phrase matching is case-insensitive", () => {
  expected("What is the LATEST update?", true, false);
  expected("What is CURRENTLY available?", true, false);
});

test("high-impact English matching is case-insensitive", () => {
  expected("Explain COPYRIGHT and TAX.", false, true);
});

test("unrelated words containing freshness fragments are not treated as freshness terms", () => {
  expected("The latestest concept is a fictional word.", false, false);
});

test("ordinary Hindi educational question is not flagged", () => {
  expected("प्रकाश संश्लेषण की प्रक्रिया समझाइए।", false, false);
});

test("freshness policy warns that no live research is attached", () => {
  const instruction = buildKnowledgePolicyInstruction({
    requiresFreshVerification: true,
    highImpact: false
  });
  assert.match(instruction, /no live research results or source documents are attached/i);
  assert.match(instruction, /Do not claim the latest status is verified/i);
});

test("high-impact policy asks for assumptions and qualified verification", () => {
  const instruction = buildKnowledgePolicyInstruction({
    requiresFreshVerification: false,
    highImpact: true
  });
  assert.match(instruction, /legal, financial, medical, or safety consequences/i);
  assert.match(instruction, /qualified professional/i);
});

test("combined policy applies freshness and high-impact safeguards", () => {
  const instruction = buildKnowledgePolicyInstruction({
    requiresFreshVerification: true,
    highImpact: true
  });
  assert.match(instruction, /Freshness guard:/);
  assert.match(instruction, /High-impact guard:/);
});

test("no flags means only baseline truthfulness safeguards are returned", () => {
  const instruction = buildKnowledgePolicyInstruction({
    requiresFreshVerification: false,
    highImpact: false
  });
  assert.match(instruction, /never invent facts/i);
  assert.doesNotMatch(instruction, /Freshness guard:/);
  assert.doesNotMatch(instruction, /High-impact guard:/);
});

test("missing classification is handled without throwing", () => {
  const instruction = buildKnowledgePolicyInstruction(null);
  assert.match(instruction, /never invent facts/i);
  assert.doesNotMatch(instruction, /Freshness guard:/);
  assert.doesNotMatch(instruction, /High-impact guard:/);
});

test("freshness-only classification does not add high-impact warning", () => {
  const instruction = buildKnowledgePolicyInstruction({
    requiresFreshVerification: true,
    highImpact: false
  });
  assert.match(instruction, /Freshness guard:/);
  assert.doesNotMatch(instruction, /High-impact guard:/);
});

test("high-impact-only classification does not add freshness warning", () => {
  const instruction = buildKnowledgePolicyInstruction({
    requiresFreshVerification: false,
    highImpact: true
  });
  assert.match(instruction, /High-impact guard:/);
  assert.doesNotMatch(instruction, /Freshness guard:/);
});

test("combined classification preserves baseline safeguards", () => {
  const instruction = buildKnowledgePolicyInstruction({
    requiresFreshVerification: true,
    highImpact: true
  });
  assert.match(instruction, /never invent facts, sources, citations/i);
  assert.match(instruction, /Do not describe model memory as a live search/i);
  assert.match(instruction, /If evidence is missing/i);
});
