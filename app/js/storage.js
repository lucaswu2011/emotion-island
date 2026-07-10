const KEYS = {
  lang: 'ei_lang',
  records: 'emotion_island_records',
  moodDiary: 'emotion_island_mood_diary',
  langGate: 'ei_lang_gate',
  provider: 'companionAIProvider',
  deepSeekKey: 'deepSeekAPIKey',
  chatSession: 'ei_chat_session',
};

export function loadLang() {
  return localStorage.getItem(KEYS.lang) || 'zh';
}

export function loadProvider() {
  return localStorage.getItem(KEYS.provider) || 'local';
}

export function saveProvider(provider) {
  localStorage.setItem(KEYS.provider, provider);
}

export function loadDeepSeekKey() {
  const stored = (localStorage.getItem(KEYS.deepSeekKey) || '').trim();
  return stored;
}

export function saveDeepSeekKey(key) {
  localStorage.setItem(KEYS.deepSeekKey, (key || '').trim());
}

export function effectiveDeepSeekKey(defaultKey) {
  return loadDeepSeekKey() || defaultKey;
}

export function saveLang(lang) {
  localStorage.setItem(KEYS.lang, lang);
}

export function langGatePassed() {
  return localStorage.getItem(KEYS.langGate) === '1';
}

export function setLangGatePassed() {
  localStorage.setItem(KEYS.langGate, '1');
}

export function loadRecords() {
  try {
    return JSON.parse(localStorage.getItem(KEYS.records) || '[]');
  } catch {
    return [];
  }
}

export function saveRecord(record) {
  const records = loadRecords();
  records.unshift(record);
  localStorage.setItem(KEYS.records, JSON.stringify(records.slice(0, 200)));
}

export function loadMoodDiary() {
  try {
    return JSON.parse(localStorage.getItem(KEYS.moodDiary) || '[]');
  } catch {
    return [];
  }
}

export function saveMoodDiary(pages) {
  localStorage.setItem(KEYS.moodDiary, JSON.stringify(pages));
}

export function dayKey(date = new Date()) {
  const d = new Date(date);
  d.setHours(0, 0, 0, 0);
  return d.toISOString().slice(0, 10);
}

export function pruneMoodDiary(pages, days = 14) {
  const cutoff = new Date();
  cutoff.setDate(cutoff.getDate() - (days - 1));
  cutoff.setHours(0, 0, 0, 0);
  return pages.filter(p => new Date(p.dayStart) >= cutoff);
}

export function tagStyleFor(index, hour = new Date().getHours()) {
  const time = hour < 12 ? 'dawn' : hour < 17 ? 'noon' : hour < 21 ? 'dusk' : 'night';
  const palette = [time, 'mint', 'blush', 'sky', 'noon', 'dusk'];
  return palette[index % palette.length];
}

/* ── Chat session persistence (DeepSeek memory across refresh) ── */

export function saveChatSession(session) {
  if (!session?.messages?.length) return;
  const data = {
    messages: session.messages,
    turnCount: session.turnCount,
    usedReplyKeys: [...(session.usedReplyKeys || [])],
    dominantIntent: session.dominantIntent,
    userLanguage: session.userLanguage,
    accumulated: session.accumulated,
    providerUsed: session.providerUsed,
    lastError: session.lastError,
    analysisUserText: session.analysisUserText || null,
    savedAt: Date.now(),
  };
  try {
    localStorage.setItem(KEYS.chatSession, JSON.stringify(data));
  } catch { /* quota exceeded — ignore */ }
}

export function loadChatSession() {
  try {
    const raw = localStorage.getItem(KEYS.chatSession);
    if (!raw) return null;
    const data = JSON.parse(raw);
    data.usedReplyKeys = new Set(data.usedReplyKeys || []);
    return data;
  } catch {
    return null;
  }
}

export function clearChatSession() {
  localStorage.removeItem(KEYS.chatSession);
}
