import { analyze, islandMessage, intentLabel } from './emotion-analyzer.js';
import { matchScenario, matchLocalGuard, detectTone } from './scenario-library.js';
import { deepSeekComplete, replyEmojis, DEFAULT_API_KEY } from './deepseek-client.js';
import { t } from './strings.js';

const CRISIS_KW = ['想死', '自杀', '自残', '不想活', 'suicide', 'kill myself', 'self-harm'];
const THANKS_KW = ['谢谢', '感谢', '好多了', 'thank you', 'thanks', 'feel better'];
const BYE_KW = ['再见', '先这样', '不说了', '拜拜', 'goodbye', 'bye', 'gotta go'];

function contains(text, kw) {
  const lowerText = text.toLowerCase();
  const lowerKw = kw.toLowerCase();
  let idx = 0;
  while ((idx = lowerText.indexOf(lowerKw, idx)) >= 0) {
    if (idx > 0 && '不没别无未'.includes(lowerText[idx - 1])) {
      idx += lowerKw.length;
      continue;
    }
    return true;
  }
  return false;
}

function seedFrom(text, turn) {
  let h = turn;
  for (let i = 0; i < text.length; i++) h = (h * 31 + text.charCodeAt(i)) | 0;
  return Math.abs(h);
}

const FALLBACK = {
  zh: {
    positive: [
      '听起来是件好事，我也替你开心。',
      '这种快乐值得好好享受一下。',
      '哇，你开心的样子连文字都快藏不住了！',
      '真好真好，这份快乐你值得拥有，好好享受呀。',
      '看到你心情这么好，小岛上的叶子都跟着亮起来了。',
      '开心的事说出来了就是双倍快乐～',
      '这种感觉太棒了，替你高兴！',
      '好心情就是要像这样被好好看见和珍惜的。',
      '你开心，我也跟着为你开心呀。',
      '能感受到你此刻的快乐，真好。',
      '这种发自内心的开心最珍贵了。',
      '今天因为你这句话，小岛也变得温暖了好多。',
      '快乐从来不怕被分享，谢谢你告诉我。',
      '开心的你，让人忍不住也跟着笑起来。',
      '这种感觉好好记住，不开心的时候翻出来看看。',
      '是你努力换来的好心情，完完全全配得上。',
      '这份快乐可太真实了，替你感到高兴。',
      '被你的快乐感染到了，真好。',
      '喜悦的事情即使再小，也值得被好好说出口。',
      '看到你幸福的样子，就是这座小岛存在的意义呀。',
    ],
    negative: [
      '嗯，愿意说出来就已经很勇敢了。我在这儿，想说什么都可以。',
      '听着就挺不容易的，慢慢讲，不用整理语言。',
      '抱抱你，这种感受一定很难受吧。',
      '没关系的，想说什么就说什么，不想说也可以不说。',
      '你不需要一个人消化这些，我会在这里陪着你。',
      '我听到你话里的沉重了。不着急，慢慢来。',
      '有些感受说出来就已经轻了一点点，你做得很好。',
      '这样的时刻不需要强撑，允许自己感受就好。',
      '难过也好，低落也好，都是真实的你的一部分。',
      '不用急着好起来。慢慢来，我在这儿不催你。',
      '你不用说漂亮话，只要说真话就好。',
      '累了就停下来喘口气，这里没有截止日期。',
      '你的情绪在这里都被允许，没有对错，没有评判。',
      '说出来不一定要解决什么，被听见本身就是重要的。',
      '我知道这种感觉不容易，你能面对它已经很了不起了。',
      '我会在这里，听着你想说的每一句。',
      '就算只是沉默也没关系，安静的陪伴也是一种陪伴。',
      '你不需要完美，不需要坚强，做此刻的你就好。',
      '这些话能说给我听，谢谢你信任我。',
      '不舒服的时候不用一个人扛着，我一直在。',
    ],
    neutral: [
      '嗯，我在听。想多说一点也可以，不想说也没关系。',
      '平平淡淡也是一种状态，我就在这里陪你。',
      '今天有什么想说的吗？没有的话，安安静静也很好。',
      '有时候不说太多，也是一种自在的方式。',
      '我在呢，你想说什么都可以，不着急。',
      '普通的一天也是真实的一天，不必非得精彩。',
      '不用刻意找话题，安安静静待一会儿就很好了。',
      '不管你想说什么，或者什么都不说，我都在。',
      '放松一点就好，不用整理语言。',
      '在这里你不用扮演任何角色，做自己最真实的样子就好。',
      '安静的时刻也是被完全允许的。',
      '如果有什么想分享的，我随时在这儿听着。',
      '哪怕只是一声轻轻的感慨，我也能感受到。',
      '漫无目的地说点什么，本身也是一种放松的方式。',
      '今天可以就这样安静地待一会儿，不急。',
      '等你准备好了再说，我没有任何期待。',
      '有时候什么都不说，比说些客套话舒服多了。',
      '真正的陪伴不一定要有话题，安静也是一种连接。',
      '思绪飘到哪就说到哪，这里没有规则。',
      '在岛上不用客气，安静或说话，随你心意就好。',
    ],
  },
  en: {
    positive: [
      "That sounds like good news — I'm happy for you.",
      'Joy like this is worth savoring.',
      "Your happiness is so real — I can feel it through your words!",
      "You absolutely deserve this good feeling. Soak it in.",
      "Seeing you happy makes the whole island feel brighter.",
      "Good news shared is happiness doubled — thank you for telling me.",
      "That's wonderful — I'm genuinely glad for you.",
      "A moment like this deserves to be seen and celebrated.",
      "Your joy warms the island too, you know.",
      "I love that you're feeling this good. Tell me more if you like.",
      "This kind of happiness is precious — hold onto it.",
      "You've made today feel lighter just by sharing that.",
      "Happiness is never wasted when shared. Thank you.",
      "The way your excitement comes through is contagious!",
      "This feeling — let yourself sit with it and enjoy it.",
      "You worked for this joy, and you absolutely earned it.",
      "Your good mood just made my little island a happier place.",
      "I'm smiling with you right now. That's how good this feels.",
      "Even the small joys are worth saying out loud.",
      "Seeing you thrive — that's what this island is here for.",
    ],
    negative: [
      "It took courage to say that. I'm here — say as much or as little as you want.",
      "That sounds heavy. Take your time — I'm listening.",
      "I'm so sorry you're feeling this way. You're not alone.",
      "You don't have to carry all of this by yourself. I'm here.",
      "I hear the weight in your words. No rush at all.",
      "Saying it out loud already lightens it a little. You're doing well.",
      "You don't need to be strong right now. Just be.",
      "Let yourself feel whatever comes up — it's all allowed here.",
      "You don't have to have the right words. Just real ones.",
      "It's okay to rest. There's no deadline here, no pressure.",
      "Your feelings are valid — every single one of them.",
      "Saying it isn't about fixing anything. Being heard matters.",
      "I know this isn't easy. Thank you for trusting me with it.",
      "I'm not going anywhere. Take as long as you need.",
      "Silence is okay too. Just sitting together counts as company.",
      "You don't have to be okay. You don't have to be anything right now.",
      "Thank you for sharing this with me. It means a lot.",
      "Heavy feelings don't have to be carried alone.",
      "I'll stay right here with you. You're not alone.",
      "Whatever you feel right now — it's okay. I'm here.",
    ],
    neutral: [
      "I'm listening. Share more if you want, or we can just sit with it.",
      "An ordinary moment is still a real one.",
      "Anything on your mind? If not, just resting together is fine.",
      "Sometimes not saying much is its own kind of comfort.",
      "I'm here — whatever you want to share, whenever.",
      "A quiet day is still a real day. No need for excitement.",
      "We can just sit in silence. That's allowed here.",
      "Whatever you say — or don't say — I'm with you.",
      "No need to find the perfect words. Just whatever comes.",
      "You don't have to perform anything here. Just be yourself.",
      "Quiet moments are welcome on this island too.",
      "If you ever feel like sharing, I'm always here to listen.",
      "Even a soft sigh — I can hear that too.",
      "Just letting your thoughts wander is a kind of rest.",
      "We can just be still for now. It's okay.",
      "No rush. I'll be here when you're ready.",
      "Sometimes saying nothing is better than saying something fake.",
      "Real company doesn't need constant conversation.",
      "Let your mind go wherever it wants. No rules here.",
      "Rest or talk — either way, you're welcome on this island.",
    ],
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

function isOnline() {
  return typeof navigator !== 'undefined' ? navigator.onLine : true;
}

function resolveProvider(provider) {
  if (provider === 'deepseek' && !isOnline()) return 'local';
  return provider;
}

export async function startSession(result, lang, provider = 'local', apiKey = DEFAULT_API_KEY) {
  const reply = await openingReply(result, lang, provider, apiKey);
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
    providerUsed: reply.providerUsed || provider,
    lastError: reply.error || null,
  };
}

async function openingReply(result, lang, provider, apiKey) {
  const text = result.userText;
  const usedKeys = new Set();
  const tone = detectTone(text);

  if (CRISIS_KW.some(k => contains(text, k))) {
    return { ...crisisReply(lang), providerUsed: 'local' };
  }

  const guard = await matchLocalGuard({
    accumulated: text, current: text, tone, lang, usedKeys, seed: seedFrom(text, 0),
  });
  if (guard) return { ...guard, providerUsed: 'local' };

  const p = resolveProvider(provider);
  if (p === 'deepseek') {
    try {
      const aiText = await deepSeekComplete({
        apiKey,
        messages: [{ role: 'user', text }],
        lang,
        intent: result.intent,
      });
      return {
        text: aiText,
        emojis: replyEmojis(result.intent, tone === 'positive' ? 'positive' : tone === 'negative' ? 'negative' : 'neutral'),
        replyKey: 'deepseek_open',
        providerUsed: 'deepseek',
      };
    } catch (e) {
      // 失败则回退本地
      const local = await localOpeningFallback(result, lang, usedKeys);
      return { ...local, providerUsed: 'local', error: e.message };
    }
  }

  return { ...(await localOpeningFallback(result, lang, usedKeys)), providerUsed: 'local' };
}

async function localOpeningFallback(result, lang, usedKeys) {
  const text = result.userText;
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

export async function continueSession(session, userInput, lang, provider = 'local', apiKey = DEFAULT_API_KEY) {
  const trimmed = userInput.trim();
  if (!trimmed) return session;

  const messages = [...session.messages, { role: 'user', text: trimmed }];
  const turnCount = session.turnCount + 1;
  const accumulated = `${session.accumulated} ${trimmed}`;
  const usedKeys = new Set(session.usedReplyKeys);
  const tone = detectTone(trimmed);
  let reply;
  let providerUsed = resolveProvider(provider);
  let lastError = null;

  if (CRISIS_KW.some(k => contains(trimmed, k))) {
    reply = crisisReply(lang);
    providerUsed = 'local';
  } else if (THANKS_KW.some(k => contains(trimmed, k))) {
    reply = {
      text: lang === 'en' ? "You're welcome. I'm glad I could be here." : '不客气，能陪着你真好。',
      emojis: ['🫂', '😊'], replyKey: 'thanks',
    };
    providerUsed = 'local';
  } else if (BYE_KW.some(k => contains(trimmed, k))) {
    reply = {
      text: lang === 'en' ? 'Okay. This island is always here when you need it.' : '好，这座小岛随时都在，需要的时候回来就好。',
      emojis: ['🌿', '💙'], replyKey: 'bye',
    };
    providerUsed = 'local';
  } else {
    const guard = await matchLocalGuard({
      accumulated: session.accumulated,
      current: trimmed,
      tone,
      lang,
      usedKeys,
      seed: seedFrom(trimmed, turnCount),
    });
    if (guard) {
      reply = guard;
      providerUsed = 'local';
    } else if (providerUsed === 'deepseek') {
      try {
        const analysis = await analyze(accumulated);
        const aiText = await deepSeekComplete({
          apiKey,
          messages,
          lang,
          intent: analysis.intent,
        });
        reply = {
          text: aiText,
          emojis: replyEmojis(analysis.intent, tone === 'positive' ? 'positive' : tone === 'negative' ? 'negative' : 'neutral'),
          replyKey: `deepseek_${turnCount}`,
        };
      } catch (e) {
        lastError = e.message;
        providerUsed = 'local';
        reply = await matchScenario({
          accumulated: session.accumulated,
          current: trimmed,
          tone,
          lang,
          usedKeys,
          seed: seedFrom(trimmed, turnCount),
        }) || {
          text: pickFallback(tone === 'positive' ? 'positive' : tone === 'negative' ? 'negative' : 'neutral', lang, seedFrom(trimmed, turnCount)),
          emojis: ['🫂', '🌿'],
          replyKey: `fb_${turnCount}`,
        };
      }
    } else {
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
    providerUsed,
    lastError,
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

export { isOnline };
