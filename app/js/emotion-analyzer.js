import { INTENT_META, t } from './strings.js';

let rulesData = null;

export async function loadRules() {
  if (!rulesData) {
    const res = await fetch('./js/emotion-rules.json');
    rulesData = await res.json();
  }
  return rulesData;
}

function contains(text, kw) {
  return text.toLowerCase().includes(kw.toLowerCase());
}

function detectContexts(text, data) {
  const contexts = [];
  if (data.boundaryKeywords.some(k => text.includes(k) || contains(text, k))) contexts.push('boundaryViolation');
  if (data.conflictKeywords.some(k => text.includes(k) || contains(text, k))) contexts.push('interpersonalConflict');
  if (['不公平', '凭什么', '太过分', '欺负人'].some(k => text.includes(k))) contexts.push('unfairness');
  if (['失去', '丢了', '没了', '离开'].some(k => text.includes(k))) contexts.push('loss');
  return contexts;
}

function extractCause(text) {
  for (const sep of ['因为', '由于', '原因是', 'because', 'since', 'due to']) {
    const idx = text.toLowerCase().indexOf(sep.toLowerCase());
    if (idx >= 0) {
      const cause = text.slice(idx + sep.length).replace(/^[，。！？、；：\s]+/, '').trim();
      if (cause) return cause;
    }
  }
  return null;
}

function inferSentiment(text, cause, contexts) {
  const map = [
    { words: ['怒', '气', '恨', '讨厌', 'angry', 'mad', 'furious'], intent: 'anger', confidence: 0.75 },
    { words: ['委屈', '烦', '闷', 'wronged', 'frustrated'], intent: 'frustration', confidence: 0.74 },
    { words: ['怕', '惧', '忧', 'scared', 'afraid', 'fear'], intent: 'fear', confidence: 0.73 },
    { words: ['累', '疲', '倦', 'tired', 'exhausted', 'drained'], intent: 'exhaustion', confidence: 0.73 },
    { words: ['迷茫', '困惑', 'confused', 'lost'], intent: 'confusion', confidence: 0.72 },
    { words: ['失望', '落', 'disappointed'], intent: 'disappointment', confidence: 0.72 },
    { words: ['孤独', '寂寞', '痛', '哭', '压抑', '沉重', 'sad', 'lonely', 'hurt'], intent: 'sadness', confidence: 0.74 },
    { words: ['乐', '喜', '幸福', 'happy', 'glad', 'joy'], intent: 'joy', confidence: 0.72 },
  ];
  let intent = 'unknown', confidence = 0.65, triggers = [];
  for (const entry of map) {
    for (const w of entry.words) {
      if (contains(text, w)) {
        triggers.push(w);
        if (entry.confidence > confidence) { intent = entry.intent; confidence = entry.confidence; }
      }
    }
  }
  if (contexts.includes('boundaryViolation')) { intent = 'anger'; confidence = Math.max(confidence, 0.88); }
  if (text.length <= 6 && (text.includes('好') || text.includes('行'))) {
    intent = 'maskedLoneliness'; triggers = [text]; confidence = 0.7;
  }
  return { intent, confidence, triggerWords: triggers.length ? [...new Set(triggers)] : [text.slice(0, 12)], detectedCause: cause, contexts };
}

export async function analyze(text) {
  const trimmed = (text || '').trim();
  const data = await loadRules();
  if (!trimmed) return emptyResult(trimmed);

  const cause = extractCause(trimmed);
  const contexts = detectContexts(trimmed, data);
  let best = null;

  for (const rule of data.rules) {
    const matched = rule.keywords.filter(kw => contains(trimmed, kw));
    if (!matched.length) continue;
    let score = rule.confidence + rule.priority * 0.005;
    score += Math.max(...matched.map(m => m.length)) * 0.003;
    score += matched.length * 0.015;
    if (rule.intent === 'anger' && contexts.includes('boundaryViolation')) score += 0.04;
    if (!best || score > best.score) best = { rule, matched, score };
  }

  if (best) {
    let intent = best.rule.intent;
    let triggers = [...new Set(best.matched)];
    let confidence = Math.min(best.score, 0.99);
    if (intent !== 'anger' && contexts.includes('boundaryViolation')) {
      intent = 'anger';
      confidence = Math.max(confidence, 0.91);
      triggers.push(...data.boundaryKeywords.filter(k => trimmed.includes(k) || contains(trimmed, k)));
    }
    return { intent, confidence, triggerWords: [...new Set(triggers)], userText: trimmed, detectedCause: cause, contexts };
  }

  const inferred = inferSentiment(trimmed, cause, contexts);
  return { ...inferred, userText: trimmed };
}

function emptyResult(text) {
  return { intent: 'unknown', confidence: 0, triggerWords: [], userText: text, detectedCause: null, contexts: [] };
}

export function intentLabel(intent, lang) {
  return INTENT_META[intent]?.[lang] || INTENT_META.unknown[lang];
}

export function intentEmoji(intent) {
  return INTENT_META[intent]?.emoji || '📝';
}

export function islandMessage(result, lang) {
  const ok = ['今天还好', '今天还行', '还行吧', "i'm fine", 'im fine', 'doing okay'];
  if (ok.some(k => result.userText.toLowerCase().includes(k.toLowerCase()))) {
    return lang === 'en' ? 'An ordinary day is a real day.' : '平平淡淡才是真。';
  }
  if (result.intent === 'anger' && result.contexts?.includes('boundaryViolation')) {
    return lang === 'en' ? 'Someone crossed a line — anger makes sense.' : '东西被动了，生气是应该的。';
  }
  if (result.intent === 'frustration') {
    return lang === 'en' ? "You don't have to swallow this alone." : '憋屈的时候，不用一个人消化。';
  }
  const defaults = {
    maskedLoneliness: { zh: '有些话，不一定要说得完整。', en: "You don't have to say it all at once." },
    sadness: { zh: '低落的时候，不用一个人扛。', en: "You don't have to carry low mood alone." },
    joy: { zh: '开心值得被好好看见。', en: 'Joy is worth celebrating.' },
    anxiety: { zh: '紧张的时候，先喘口气。', en: 'Take a breath — anxiety is real.' },
    anger: { zh: '生气也是一种真实的感受。', en: 'Anger is a real feeling too.' },
    exhaustion: { zh: '累了就允许自己歇一歇。', en: 'Rest when you need to.' },
    confusion: { zh: '迷茫的时候，写下来就好。', en: "When you're lost, writing is enough." },
    neutralMasking: { zh: '还好，也是一种真实的状态。', en: '"Okay" is still a real state.' },
    unknown: { zh: '小助手在听。', en: 'Companion is listening.' },
  };
  return defaults[result.intent]?.[lang] || defaults.unknown[lang];
}

export function detailedResponse(result, lang) {
  const name = intentLabel(result.intent, lang);
  if (lang === 'en') {
    return `I hear **${name}** in what you wrote. Want to share a little more? I'm here.`;
  }
  return `我听见你话里的**${name}**。愿意多说一点吗？我在这儿。`;
}

export function demoJSON(result, lang) {
  return JSON.stringify({
    intent: result.intent,
    confidence: Number(result.confidence.toFixed(2)),
    triggers: result.triggerWords,
    cause: result.detectedCause,
    contexts: result.contexts,
    island: islandMessage(result, lang),
  }, null, 2);
}
