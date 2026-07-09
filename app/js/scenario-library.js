let templates = null;

export async function loadScenarios() {
  if (!templates) {
    const res = await fetch('./js/scenario-data.json');
    templates = await res.json();
  }
  return templates;
}

const BULLYING_KW = [
  '霸凌', '欺负', '被同学打', '起外号', '排挤', '孤立', '造谣', '堵在厕所', '堵在走廊',
  '勒索', '抢我东西', 'bully', 'bullied', 'mocked me', 'left out', 'excluded',
];

function contains(text, kw) {
  const lowerText = text.toLowerCase();
  const lowerKw = kw.toLowerCase();
  let idx = 0;
  while ((idx = lowerText.indexOf(lowerKw, idx)) >= 0) {
    // 中文否定前缀：被 不/没/别/无/未 修饰时不匹配
    if (idx > 0 && '不没别无未'.includes(lowerText[idx - 1])) {
      idx += lowerKw.length;
      continue;
    }
    return true;
  }
  return false;
}

function matchScore(template, text) {
  const hits = template.keywords.filter(kw => contains(text, kw)).length;
  if (!hits) return 0;
  return hits * 10 + template.priority;
}

function resolveTone(accumulated, current, tone) {
  const neg = ['难过', '生气', '委屈', '害怕', '累', '焦虑', '失望', 'sad', 'angry', 'tired', 'scared'];
  const pos = ['开心', '高兴', '快乐', '幸福', 'happy', 'glad', 'excited', 'thrilled'];
  const t = `${accumulated} ${current}`.toLowerCase();
  if (neg.some(k => t.includes(k))) return 'negative';
  if (pos.some(k => t.includes(k))) return 'positive';
  return tone || 'neutral';
}

function poolForTone(tone, all) {
  if (tone === 'positive') return all.filter(t => t.tone === 'positive');
  if (tone === 'negative') return all.filter(t => t.tone === 'negative');
  return all.filter(t => t.tone === 'neutral');
}

function bestMatch(accumulated, current, pool, currentOnly = false) {
  const text = currentOnly ? current : `${accumulated} ${current}`;
  let best = null;
  for (const template of pool) {
    const score = matchScore(template, text);
    if (score > 0 && (!best || score > best.score)) best = { template, score };
  }
  return best;
}

function matchBullying(accumulated, current) {
  const text = `${accumulated} ${current}`;
  if (!BULLYING_KW.some(k => contains(text, k))) return null;
  return bestMatch(accumulated, current, templates.filter(t => t.id.startsWith('bully_')), false)?.template;
}

function pickLine(arr, seed) {
  if (!arr?.length) return '';
  return arr[Math.abs(seed) % arr.length];
}

export async function matchScenario({ accumulated, current, tone, lang, usedKeys, seed }) {
  const hit = await findBestTemplate(accumulated, current, tone);
  if (!hit) return null;
  return buildReply(hit.template, lang, usedKeys, seed, hit.template.comfortOnly || hit.template.gentleOnly);
}

async function findBestTemplate(accumulated, current, tone) {
  await loadScenarios();
  const matchTone = resolveTone(accumulated, current, tone);

  const bullying = matchBullying(accumulated, current);
  if (bullying) return { template: bullying, score: 999 };

  let pool = poolForTone(matchTone, templates);
  let hit = bestMatch(accumulated, current, pool, false);
  if (!hit && matchTone === 'neutral') {
    hit = bestMatch(accumulated, current, templates.filter(t => t.tone === 'negative'), false)
      || bestMatch(accumulated, current, templates.filter(t => t.tone === 'positive'), false);
  }
  if (!hit) hit = bestMatch(accumulated, current, templates, false);
  return hit;
}

/** DeepSeek 模式下高敏感场景走本地话术 */
export async function matchLocalGuard({ accumulated, current, tone, lang, usedKeys, seed }) {
  await loadScenarios();
  if (BULLYING_KW.some(k => contains(`${accumulated} ${current}`, k))) {
    const bullying = matchBullying(accumulated, current);
    if (bullying) return buildReply(bullying, lang, usedKeys, seed, true);
  }
  const hit = await findBestTemplate(accumulated, current, tone);
  if (!hit) return null;
  const t = hit.template;
  if (t.comfortOnly || t.gentleOnly || t.id.startsWith('bully_') || t.id.includes('domestic') || t.id.includes('violence')) {
    return buildReply(t, lang, usedKeys, seed, true);
  }
  return null;
}

function buildReply(template, lang, usedKeys, seed, noFollowUp) {
  const responses = (lang === 'en' && template.responsesEN?.length) ? template.responsesEN : template.responses;
  const followUps = (lang === 'en' && template.followUpsEN?.length) ? template.followUpsEN : template.followUps;
  const keyBase = template.id;
  let idx = 0;
  while (usedKeys.has(`${keyBase}_${idx}`) && idx < responses.length) idx++;
  const text = responses[idx % responses.length];
  usedKeys.add(`${keyBase}_${idx}`);
  let full = text;
  if (!noFollowUp && followUps?.length && Math.random() < 0.6) {
    full += ' ' + pickLine(followUps, seed + idx);
  }
  return { text: full, emojis: template.emojis || ['🫂', '🌿'], replyKey: `${keyBase}_${idx}` };
}

export function detectTone(text) {
  const neg = ['难过', '伤心', '生气', '委屈', '害怕', '累', '焦虑', '失望', '烦', 'sad', 'angry', 'tired', 'upset'];
  const pos = ['开心', '高兴', '快乐', '幸福', '棒', '第一', 'happy', 'glad', 'excited', 'great'];
  if (neg.some(k => contains(text, k))) return 'negative';
  if (pos.some(k => contains(text, k))) return 'positive';
  return 'neutral';
}
