import { analyze, islandMessage, intentLabel } from './emotion-analyzer.js';
import { matchScenario, detectTone } from './scenario-library.js';
import { t } from './strings.js';

const CRISIS_KW = ['想死', '自杀', '自残', '不想活', 'suicide', 'kill myself', 'self-harm'];
const THANKS_KW = ['谢谢', '感谢', '好多了', 'thank you', 'thanks', 'feel better'];
const BYE_KW = ['再见', '先这样', '不说了', '拜拜', 'goodbye', 'bye', 'gotta go'];

function contains(text, kw) {
  return text.toLowerCase().includes(kw.toLowerCase());
}

function seedFrom(text, turn) {
  let h = turn;
  for (let i = 0; i < text.length; i++) h = (h * 31 + text.charCodeAt(i)) | 0;
  return Math.abs(h);
}

const FALLBACK = {
  zh: {
    positive: ['听起来是件好事，我也替你开心。', '这种快乐值得好好享受一下。'],
    negative: ['嗯，愿意说出来就已经很勇敢了。我在这儿，想说什么都可以。', '听着就挺不容易的，慢慢讲，不用整理语言。'],
    neutral: ['嗯，我在听。想多说一点也可以，不想说也没关系。'],
  },
  en: {
    positive: ["That sounds like good news — I'm happy for you.", 'Joy like this is worth savoring.'],
    negative: ["It took courage to say that. I'm here — say as much or as little as you want.", "That sounds heavy. Take your time — I'm listening."],
    neutral: ["I'm listening. Share more if you want, or we can just sit with it."],
  },
};

function crisisReply(lang) {
  const text = lang === 'en'
    ? "I'm really glad you said something. You don't have to face this alone — if you're in immediate danger, please reach local emergency or crisis support. I'm here with you."
    : '你愿意说出来，这本身就很勇敢。如果你现在有危险，请尽快联系身边可信的人或当地危机援助。我在这儿陪着你。';
  return { text, emojis: ['🫂', '💙'], replyKey: 'crisis' };
}

function pickFallback(tone, lang, seed) {
  const pool = FALLBACK[lang][tone] || FALLBACK[lang].neutral;
  return pool[seed % pool.length];
}

export async function startSession(result, lang) {
  const reply = await openingReply(result, lang);
  return {
    messages: [
      { role: 'user', text: result.userText },
      { role: 'assistant', text: reply.text, emojis: reply.emojis },
    ],
    turnCount: 0,
    usedReplyKeys: new Set([reply.replyKey]),
    dominantIntent: result.intent,
    userLanguage: lang,
    accumulated: result.userText,
  };
}

async function openingReply(result, lang) {
  const text = result.userText;
  if (CRISIS_KW.some(k => contains(text, k))) return crisisReply(lang);

  const usedKeys = new Set();
  const tone = detectTone(text);
  const scenario = await matchScenario({
    accumulated: text, current: text, tone, lang, usedKeys, seed: seedFrom(text, 0),
  });
  if (scenario) return scenario;

  const okReplies = {
    zh: '嗯，还好也是一种真实的状态。今天有什么想随便聊聊的吗？',
    en: '"Okay" is still a real state. Anything you feel like sharing today?',
  };
  if (['今天还好', '今天还行', '还行吧', "i'm fine", 'im fine'].some(k => contains(text, k))) {
    return { text: okReplies[lang], emojis: ['🌿', '😊'], replyKey: 'open_okay' };
  }

  return {
    text: pickFallback(tone === 'positive' ? 'positive' : tone === 'negative' ? 'negative' : 'neutral', lang, seedFrom(text, 1)),
    emojis: tone === 'positive' ? ['😊', '✨'] : ['🫂', '🌿'],
    replyKey: 'open_fallback',
  };
}

export async function continueSession(session, userInput, lang) {
  const trimmed = userInput.trim();
  if (!trimmed) return session;

  const messages = [...session.messages, { role: 'user', text: trimmed }];
  const turnCount = session.turnCount + 1;
  const accumulated = `${session.accumulated} ${trimmed}`;
  const usedKeys = new Set(session.usedReplyKeys);

  let reply;
  if (CRISIS_KW.some(k => contains(trimmed, k))) {
    reply = crisisReply(lang);
  } else if (THANKS_KW.some(k => contains(trimmed, k))) {
    reply = {
      text: lang === 'en' ? "You're welcome. I'm glad I could be here." : '不客气，能陪着你真好。',
      emojis: ['🫂', '😊'], replyKey: 'thanks',
    };
  } else if (BYE_KW.some(k => contains(trimmed, k))) {
    reply = {
      text: lang === 'en' ? 'Okay. This island is always here when you need it.' : '好，这座小岛随时都在，需要的时候回来就好。',
      emojis: ['🌿', '💙'], replyKey: 'bye',
    };
  } else {
    const tone = detectTone(trimmed);
    reply = await matchScenario({
      accumulated: session.accumulated,
      current: trimmed,
      tone,
      lang,
      usedKeys,
      seed: seedFrom(trimmed, turnCount),
    });
    if (!reply) {
      reply = {
        text: pickFallback(tone === 'positive' ? 'positive' : tone === 'negative' ? 'negative' : 'neutral', lang, seedFrom(trimmed, turnCount)),
        emojis: ['🫂', '🌿'],
        replyKey: `fb_${turnCount}`,
      };
    }
  }

  usedKeys.add(reply.replyKey);
  messages.push({ role: 'assistant', text: reply.text, emojis: reply.emojis });

  const analysis = await analyze(accumulated);
  return {
    ...session,
    messages,
    turnCount,
    usedReplyKeys: usedKeys,
    dominantIntent: analysis.intent,
    accumulated,
    userLanguage: lang,
  };
}

export function chatIslandMessage(session, initialResult, lang) {
  if (!session?.messages?.length && initialResult) return islandMessage(initialResult, lang);
  const lastUser = [...session.messages].reverse().find(m => m.role === 'user');
  if (!lastUser) return t(lang, 'companionListening');
  const tone = detectTone(lastUser.text);
  if (tone === 'positive') return lang === 'en' ? 'Good energy — tell me more!' : '这股开心劲儿，想多听一点！';
  if (tone === 'negative') return lang === 'en' ? "I'm here — no rush." : '不催你，慢慢讲。';
  return lang === 'en' ? 'Listening…' : '小助手在听…';
}

export function intentName(intent, lang) {
  return intentLabel(intent, lang);
}
