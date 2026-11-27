import test from "node:test";
import assert from "node:assert/strict";
import {
  classifyKnowledgeNeed,
  buildKnowledgePolicyInstruction
} from "./knowledge_policy.mjs";

test("flags current English questions for fresh verification", () => {
  assert.deepEqual(classifyKnowledgeNeed("What is the latest market price?"), {
    requiresFreshVerification: true,
    highImpact: false
  });
});

test("flags current Hindi questions for fresh verification", () => {
  assert.equal(
    classifyKnowledgeNeed("आज के ताज़ा सरकारी नियम क्या हैं?")
      .requiresFreshVerification,
    true
  );
});

test("flags legal and copyright topics as high impact", () => {
  assert.equal(
    classifyKnowledgeNeed("Can I use this image commercially under copyright law?")
      .highImpact,
    true
  );
});

test("flags Hindi tax and health topics as high impact", () => {
  assert.equal(classifyKnowledgeNeed("जीएसटी नियम क्या हैं?").highImpact, true);
  assert.equal(classifyKnowledgeNeed("इस दवा की खुराक कितनी होनी चाहिए?").highImpact, true);
});

test("does not flag a stable general programming question", () => {
  assert.deepEqual(classifyKnowledgeNeed("Explain what a variable is in programming."), {
    requiresFreshVerification: false,
    highImpact: false
  });
});

test("freshness guard forbids claiming live verification without sources", () => {
  const instruction = buildKnowledgePolicyInstruction({
    requiresFreshVerification: true,
    highImpact: false
  });
  assert.match(instruction, /no live research results or source documents are attached/i);
  assert.match(instruction, /Do not claim the latest status is verified/i);
});

test("high-impact guard requires assumptions and appropriate verification", () => {
  const instruction = buildKnowledgePolicyInstruction({
    requiresFreshVerification: false,
    highImpact: true
  });
  assert.match(instruction, /legal, financial, medical, or safety consequences/i);
  assert.match(instruction, /qualified professional/i);
});

test("combined guard applies both freshness and high-impact rules", () => {
  const instruction = buildKnowledgePolicyInstruction({
    requiresFreshVerification: true,
    highImpact: true
  });
  assert.match(instruction, /Freshness guard:/);
  assert.match(instruction, /High-impact guard:/);
});
