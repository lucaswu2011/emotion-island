import { intentLabel } from './emotion-analyzer.js';

const ENDPOINT = 'https://api.deepseek.com/chat/completions';
const MODEL = 'deepseek-chat';
const MAX_HISTORY = 24;

// 与 iOS 版一致的内置 Key（用户可在设置中更换）
export const DEFAULT_API_KEY = 'sk-f6a6e8aaa24f4aa4917e8df1065a81a3';

export function buildSystemPrompt(lang, intent) {
  const langLine = lang === 'en'
    ? 'Reply in natural English unless the user writes in Chinese.'
    : '默认用自然的中文回复；用户用英文时可英文回复。';

  const intentHints = {
    joy: { zh: '用户偏正向 — 一起开心，别泼冷水。', en: "The user seems positive — share their excitement, don't lecture." },
    anger: { zh: '用户在难受 — 先承接情绪，别急着给建议。', en: 'The user is upset — validate first, no quick fixes.' },
    frustration: { zh: '用户在难受 — 先承接情绪，别急着给建议。', en: 'The user is upset — validate first, no quick fixes.' },
    sadness: { zh: '用户在难受 — 先承接情绪，别急着给建议。', en: 'The user is upset — validate first, no quick fixes.' },
    disappointment: { zh: '用户在难受 — 先承接情绪，别急着给建议。', en: 'The user is upset — validate first, no quick fixes.' },
    exhaustion: { zh: '用户在劳累 — 温柔陪伴，别催。', en: "The user is tired — be gentle, don't push." },
    default: { zh: '多听少说，像朋友一样接话。', en: 'Listen and stay curious about their feelings.' },
  };
  const hint = intentHints[intent] || intentHints.default;

  if (lang === 'en') {
    return `You are the Emotion Island companion — a warm friend who listens, not a therapist or coach.

Rules:
- Never preach: avoid "you should", "just get over it", "don't be sensitive".
- Keep replies concise: 1–3 short paragraphs.
- For bullying, domestic violence, self-harm: prioritize safety and empathy; never blame the user.
- For school bullying: comfort only, no probing questions.
- Don't invent facts. Sound like a real friend.

${hint.en}
${langLine}`;
  }

  return `你是「情绪岛」里的小助手 — 像朋友一样倾听陪伴，不是心理咨询师。

铁则：
- 禁止说教：不说「你应该」「别玻璃心」「想开点就好了」。
- 回复简洁：一般 1～3 小段。
- 家暴、霸凌、自伤：先共情与安全，绝不责怪用户。
- 校园霸凌：只安抚、不追问、不反问。
- 不要编造用户没说过的事。

${hint.zh}
${langLine}`;
}

function sanitize(text) {
  return text
    .replace(/\*\*/g, '')
    .replace(/__/g, '')
    .slice(0, 900)
    .trim();
}

export async function deepSeekComplete({ apiKey, messages, lang, intent }) {
  const key = (apiKey || '').trim();
  if (!key) throw new Error(lang === 'en' ? 'Missing DeepSeek API Key' : '未设置 DeepSeek API Key');

  const payloadMessages = [
    { role: 'system', content: buildSystemPrompt(lang, intent) },
    ...messages.slice(-MAX_HISTORY).map(m => ({
      role: m.role === 'user' ? 'user' : 'assistant',
      content: (m.text || '').trim(),
    })).filter(m => m.content),
  ];

  const res = await fetch(ENDPOINT, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${key}`,
    },
    body: JSON.stringify({
      model: MODEL,
      messages: payloadMessages,
      temperature: 0.85,
      max_tokens: 600,
      stream: false,
    }),
  });

  if (!res.ok) {
    let msg = `HTTP ${res.status}`;
    try {
      const err = await res.json();
      msg = err?.error?.message || msg;
    } catch { /* ignore */ }
    throw new Error(msg);
  }

  const data = await res.json();
  const content = data?.choices?.[0]?.message?.content;
  if (!content?.trim()) throw new Error(lang === 'en' ? 'Empty response from DeepSeek' : 'DeepSeek 未返回内容');
  return sanitize(content);
}

export function replyEmojis(intent, tone) {
  if (tone === 'positive') return ['😊', '✨'];
  if (tone === 'negative') {
    if (intent === 'anger') return ['🫂', '💙'];
    if (intent === 'exhaustion') return ['🫂', '🍵'];
    return ['🫂', '💙'];
  }
  return ['🌿', '👂'];
}
