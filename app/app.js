/* Emotion Island Web App — main UI */
import { t, INTENT_META } from './js/strings.js';
import * as storage from './js/storage.js';
import { analyze, islandMessage, intentLabel, intentEmoji, detailedResponse, demoJSON } from './js/emotion-analyzer.js';
import { startSession, continueSession, chatIslandMessage, isOnline } from './js/conversation-engine.js';
import { loadScenarios } from './js/scenario-library.js';
import { DEFAULT_API_KEY } from './js/deepseek-client.js';

const state = {
  screen: 'lang',
  lang: storage.loadLang(),
  provider: storage.loadProvider(),
  deepSeekKey: storage.loadDeepSeekKey(),
  diaryText: '',
  analysis: null,
  session: null,
  history: storage.loadRecords(),
  moodPages: storage.loadMoodDiary(),
  isThinking: false,
  chatError: null,
  showKeyPanel: false,
};

const root = document.getElementById('app');
const MAX_DIARY = 200;

function esc(s) {
  const d = document.createElement('div');
  d.textContent = s ?? '';
  return d.innerHTML;
}

function nav(screen) {
  state.screen = screen;
  render();
  window.scrollTo(0, 0);
}

function pillHTML(msg, intent) {
  const meta = INTENT_META[intent] || INTENT_META.unknown;
  return `<div class="island-pill style-${meta.style}"><span class="pill-heart">♥</span><span>${esc(msg)}</span></div>`;
}

async function onAnalyze() {
  state.analysis = await analyze(state.diaryText);
  render();
}

function effectiveKey() {
  return storage.effectiveDeepSeekKey(DEFAULT_API_KEY);
}

async function onStartChat() {
  if (!state.analysis) state.analysis = await analyze(state.diaryText);
  state.isThinking = state.provider === 'deepseek';
  state.chatError = null;
  render();
  try {
    state.session = await startSession(state.analysis, state.lang, state.provider, effectiveKey());
    if (state.session.lastError) state.chatError = state.session.lastError;
    if (state.provider === 'deepseek' && !isOnline()) {
      state.chatError = t(state.lang, 'networkOffline');
      state.provider = 'local';
      storage.saveProvider('local');
    }
  } finally {
    state.isThinking = false;
    nav('chat');
  }
}

async function onSendChat(text) {
  state.isThinking = state.provider === 'deepseek';
  state.chatError = null;
  render();
  try {
    state.session = await continueSession(state.session, text, state.lang, state.provider, effectiveKey());
    if (state.session.lastError) state.chatError = t(state.lang, 'deepSeekError') + ': ' + state.session.lastError;
  } finally {
    state.isThinking = false;
    render();
  }
}

function onSaveRecord() {
  if (!state.analysis) return;
  const lastAssistant = [...state.session.messages].reverse().find(m => m.role === 'assistant');
  const record = {
    id: crypto.randomUUID(),
    userText: state.analysis.userText,
    intent: state.analysis.intent,
    triggerWords: state.analysis.triggerWords,
    messages: state.session.messages,
    assistantReply: lastAssistant?.text || '',
    savedAt: new Date().toISOString(),
  };
  storage.saveRecord(record);
  state.history = storage.loadRecords();
  updateMoodDiary(record);
  alert(`${t(state.lang, 'savedTitle')}\n${t(state.lang, 'savedMsg')}`);
  resetFlow();
}

function updateMoodDiary(record) {
  const key = storage.dayKey();
  let pages = storage.pruneMoodDiary(storage.loadMoodDiary());
  let page = pages.find(p => p.dayStart === key);
  if (!page) {
    page = { dayStart: key, stickers: [], snippet: record.userText.slice(0, 36) };
    pages.unshift(page);
  }
  if (!page.snippet) page.snippet = record.userText.slice(0, 36);
  const emoji = intentEmoji(record.intent);
  const hour = new Date().getHours();
  const idx = page.stickers.length;
  if (page.stickers.length < 3 && !page.stickers.some(s => s.intent === record.intent)) {
    page.stickers.push({
      id: crypto.randomUUID(),
      emoji,
      intent: record.intent,
      tagLabel: intentLabel(record.intent, state.lang),
      tagStyle: storage.tagStyleFor(idx, hour),
      recordedAt: new Date().toISOString(),
    });
  }
  state.moodPages = storage.pruneMoodDiary(pages);
  storage.saveMoodDiary(state.moodPages);
}

function resetFlow() {
  state.diaryText = '';
  state.analysis = null;
  state.session = null;
  nav('welcome');
}

function renderLang() {
  root.innerHTML = `
    <section class="screen lang-screen">
      <div class="lang-card">
        <h1>${esc(t('zh', 'appName'))}</h1>
        <p class="subtitle">${esc(t('zh', 'chooseLang'))}</p>
        <p class="muted">${esc(t('zh', 'chooseLangSub'))}</p>
        <div class="lang-btns">
          <button class="btn-primary" data-lang="zh">中文</button>
          <button class="btn-ghost" data-lang="en">English</button>
        </div>
        <p class="privacy-foot">${esc(t('zh', 'privacyWelcome'))}</p>
      </div>
    </section>`;
  root.querySelectorAll('[data-lang]').forEach(btn => btn.onclick = () => {
    state.lang = btn.dataset.lang;
    storage.saveLang(state.lang);
    storage.setLangGatePassed();
    nav('welcome');
  });
}

function renderWelcome() {
  const s = state.lang;
  root.innerHTML = `
    <section class="screen welcome-screen">
      <header class="top-bar"><span class="logo-small">♥ ${esc(t(s, 'appName'))}</span>
        <button class="link-btn" data-go="about">${esc(t(s, 'about'))}</button></header>
      <div class="hero-center">
        <div class="hero-icon">♥</div>
        <h1>${esc(t(s, 'appName'))}</h1>
        <p class="hero-line">${esc(t(s, 'welcome1'))}</p>
        <p class="muted">${esc(t(s, 'welcome2'))}</p>
        <div class="feat-row">
          <span>🍃 ${esc(t(s, 'featLeaf'))}</span>
          <span>💬 ${esc(t(s, 'featAI'))}</span>
          <span>🔒 ${esc(t(s, 'featLocal'))}</span>
        </div>
        <button class="btn-primary wide" data-go="diary">${esc(t(s, 'start'))}</button>
        <div class="quick-links">
          <button class="chip" data-go="moodDiary">📔 ${esc(t(s, 'moodDiary'))}</button>
          <button class="chip" data-go="history">📚 ${esc(t(s, 'fullRecords'))}</button>
          <button class="chip" data-go="demo">🌿 ${esc(t(s, 'learnAI'))}</button>
        </div>
        <p class="privacy-foot">${esc(t(s, 'privacyWelcome'))}</p>
      </div>
    </section>`;
  bindNav(root);
}

function renderDiary() {
  const s = state.lang;
  const len = state.diaryText.length;
  root.innerHTML = `
    <section class="screen diary-screen">
      <header class="top-bar"><button class="link-btn" data-go="welcome">← ${esc(t(s, 'back'))}</button></header>
      <p class="caption">${esc(t(s, 'diaryCaption'))}</p>
      <h2>${esc(t(s, 'todaySay'))}</h2>
      <textarea id="diaryInput" maxlength="${MAX_DIARY}" placeholder="${esc(t(s, 'diaryPlaceholder'))}">${esc(state.diaryText)}</textarea>
      <div class="row-between"><span class="muted">${esc(t(s, 'diaryHint'))}</span><span class="count">${len}/${MAX_DIARY}</span></div>
      <button class="chip" id="sampleBtn">${esc(t(s, 'trySample'))}</button>
      <button class="btn-primary wide" id="diaryContinue" ${len ? '' : 'disabled'}>${esc(t(s, 'continue'))}</button>
      <p class="privacy-foot">${esc(t(s, 'privacyDiary'))}</p>
    </section>`;
  const ta = root.querySelector('#diaryInput');
  ta.oninput = () => { state.diaryText = ta.value; renderDiary(); };
  root.querySelector('#sampleBtn').onclick = () => {
    state.diaryText = s === 'en' ? "I'm a little sad" : '我有点难过';
    renderDiary();
  };
  root.querySelector('#diaryContinue').onclick = async () => {
    await onAnalyze();
    nav('mood');
  };
  bindNav(root);
}

function renderMood() {
  const s = state.lang;
  const r = state.analysis;
  const msg = r ? islandMessage(r, s) : t(s, 'companionListening');
  const intents = ['joy', 'sadness', 'anger', 'frustration', 'anxiety', 'exhaustion'];
  root.innerHTML = `
    <section class="screen mood-screen">
      <header class="top-bar"><button class="link-btn" data-go="diary">← ${esc(t(s, 'back'))}</button></header>
      ${pillHTML(msg, r?.intent || 'unknown')}
      <p class="caption">${esc(t(s, 'moodFeeling'))}</p>
      <textarea id="moodInput" maxlength="${MAX_DIARY}">${esc(state.diaryText)}</textarea>
      ${r ? `<div class="analysis-card">
        <strong>${esc(intentLabel(r.intent, s))}</strong>
        <span class="muted">${Math.round(r.confidence * 100)}%</span>
        ${r.triggerWords.length ? `<div class="tags">${r.triggerWords.map(w => `<span class="tag">${esc(w)}</span>`).join('')}</div>` : ''}
      </div>` : ''}
      <div class="mood-grid">${intents.map(i => `
        <button class="mood-pick" data-intent="${i}">${INTENT_META[i].emoji}<span>${esc(intentLabel(i, s))}</span></button>`).join('')}</div>
      <button class="btn-primary wide" id="toChat">${esc(t(s, 'moodContinue'))}</button>
    </section>`;
  root.querySelector('#moodInput').oninput = async e => {
    state.diaryText = e.target.value;
    state.analysis = await analyze(state.diaryText);
    renderMood();
  };
  root.querySelectorAll('.mood-pick').forEach(btn => btn.onclick = () => {
    const samples = {
      joy: s === 'en' ? 'I feel happy today' : '今天很开心',
      sadness: s === 'en' ? "I'm a little sad" : '我有点难过',
      anger: s === 'en' ? "I'm angry" : '有点生气',
      frustration: s === 'en' ? 'I feel wronged' : '好委屈',
      anxiety: s === 'en' ? "I'm anxious" : '有点焦虑',
      exhaustion: s === 'en' ? "I'm so tired" : '好累',
    };
    state.diaryText = samples[btn.dataset.intent];
    onAnalyze().then(() => renderMood());
  });
  root.querySelector('#toChat').onclick = onStartChat;
  bindNav(root);
}

function renderChat() {
  const s = state.lang;
  const sess = state.session;
  const island = chatIslandMessage(sess, state.analysis, s);
  const usingDeepSeek = state.provider === 'deepseek';
  const privacy = usingDeepSeek ? t(s, 'deepSeekPrivacy') : t(s, 'chatPrivacy');
  root.innerHTML = `
    <section class="screen chat-screen">
      <header class="top-bar">
        <button class="link-btn" data-go="mood">←</button>
        <span>${esc(t(s, 'chatTitle'))}</span>
        <button class="link-btn" id="finishBtn">${esc(t(s, 'saveReview'))}</button>
      </header>
      <div class="provider-bar">
        <span class="provider-label">${esc(t(s, 'providerLabel'))}</span>
        <button class="chip ${state.provider === 'local' ? 'active' : ''}" data-provider="local">🌿 ${esc(t(s, 'localAI'))}</button>
        <button class="chip ${state.provider === 'deepseek' ? 'active' : ''}" data-provider="deepseek">✨ ${esc(t(s, 'deepSeek'))}</button>
        ${usingDeepSeek ? `<button class="link-btn" id="keyBtn">Key</button>` : ''}
      </div>
      ${state.showKeyPanel ? `
        <div class="key-panel">
          <label>${esc(t(s, 'deepSeekKeyTitle'))}</label>
          <input id="keyInput" type="password" placeholder="sk-..." value="${esc(state.deepSeekKey)}" />
          <p class="muted">${esc(t(s, 'deepSeekKeyHint'))}</p>
          <button class="btn-primary" id="saveKeyBtn">${esc(t(s, 'deepSeekKeySave'))}</button>
        </div>` : ''}
      ${state.chatError ? `<div class="error-banner">${esc(state.chatError)}</div>` : ''}
      ${pillHTML(island, sess.dominantIntent)}
      <p class="turn-label">${esc(t(s, 'turn', sess.turnCount))}</p>
      <div class="chat-area" id="chatArea">${sess.messages.map(m => `
        <div class="bubble ${m.role}">${esc(m.text)}${m.emojis?.length ? `<div class="emoji-strip">${m.emojis.join(' ')}</div>` : ''}</div>`).join('')}
        ${state.isThinking ? `<div class="bubble assistant typing">${esc(t(s, 'deepSeekThinking'))}</div>` : ''}</div>
      <div class="chat-input-row">
        <input id="chatInput" placeholder="${esc(t(s, 'chatPlaceholder'))}" ${state.isThinking ? 'disabled' : ''} />
        <button class="btn-primary" id="sendBtn" ${state.isThinking ? 'disabled' : ''}>${esc(t(s, 'send'))}</button>
      </div>
      <p class="privacy-foot">${esc(privacy)}</p>
      <p class="engine-badge">${usingDeepSeek ? '✨ DeepSeek · deepseek-chat' : `🌿 ${esc(t(s, 'localAI'))} · ${esc(t(s, 'localAIDesc'))}`}</p>
    </section>`;
  const area = root.querySelector('#chatArea');
  area.scrollTop = area.scrollHeight;
  const input = root.querySelector('#chatInput');
  const send = async () => {
    const v = input.value.trim();
    if (!v || state.isThinking) return;
    input.value = '';
    await onSendChat(v);
  };
  root.querySelector('#sendBtn')?.addEventListener('click', send);
  input?.addEventListener('keydown', e => { if (e.key === 'Enter') send(); });
  root.querySelector('#finishBtn')?.addEventListener('click', () => nav('summary'));
  root.querySelectorAll('[data-provider]').forEach(btn => {
    btn.onclick = () => {
      const p = btn.dataset.provider;
      if (p === 'deepseek' && !isOnline()) {
        state.chatError = t(s, 'networkOffline');
        state.provider = 'local';
      } else {
        state.provider = p;
        state.chatError = null;
      }
      storage.saveProvider(state.provider);
      renderChat();
    };
  });
  root.querySelector('#keyBtn')?.addEventListener('click', () => {
    state.showKeyPanel = !state.showKeyPanel;
    renderChat();
  });
  root.querySelector('#saveKeyBtn')?.addEventListener('click', () => {
    state.deepSeekKey = root.querySelector('#keyInput').value.trim();
    storage.saveDeepSeekKey(state.deepSeekKey);
    state.showKeyPanel = false;
    renderChat();
  });
  bindNav(root);
}

function renderSummary() {
  const s = state.lang;
  const r = state.analysis;
  const last = [...state.session.messages].reverse().find(m => m.role === 'assistant');
  root.innerHTML = `
    <section class="screen summary-screen">
      <h2>${esc(t(s, 'summaryTitle'))}</h2>
      <div class="summary-grid">
        <div class="summary-card"><label>${esc(t(s, 'summaryEmotion'))}</label><strong>${esc(intentLabel(r.intent, s))}</strong></div>
        <div class="summary-card"><label>${esc(t(s, 'summaryTriggers'))}</label><strong>${esc(r.triggerWords.join('、') || '—')}</strong></div>
        <div class="summary-card"><label>${esc(t(s, 'summaryStyle'))}</label><p>${esc(last?.text || '')}</p></div>
        <div class="summary-card"><label>${esc(t(s, 'summaryStorage'))}</label><strong>${esc(t(s, 'summaryStorageVal'))}</strong></div>
      </div>
      <button class="btn-ghost wide" data-go="diary">${esc(t(s, 'backDiary'))}</button>
      <button class="btn-primary wide" id="saveBtn">${esc(t(s, 'saveRecord'))}</button>
    </section>`;
  root.querySelector('#saveBtn').onclick = onSaveRecord;
  bindNav(root);
}

function renderHistory() {
  const s = state.lang;
  const records = storage.loadRecords();
  root.innerHTML = `
    <section class="screen history-screen">
      <header class="top-bar"><button class="link-btn" data-go="welcome">← ${esc(t(s, 'home'))}</button>
        <span>${esc(t(s, 'historyTitle'))}</span></header>
      ${records.length ? records.map(r => `
        <article class="history-card">
          <div class="history-meta">${new Date(r.savedAt).toLocaleString(s === 'en' ? 'en-US' : 'zh-CN')} · ${esc(intentLabel(r.intent, s))}</div>
          <p class="history-text">${esc(r.userText)}</p>
          <p class="muted">${esc(r.assistantReply?.slice(0, 80) || '')}…</p>
        </article>`).join('') : `<div class="empty"><h3>${esc(t(s, 'historyEmpty'))}</h3><p>${esc(t(s, 'historyEmptySub'))}</p></div>`}
    </section>`;
  bindNav(root);
}

function renderMoodDiary() {
  const s = state.lang;
  const pages = storage.pruneMoodDiary(storage.loadMoodDiary());
  state.moodPages = pages;
  root.innerHTML = `
    <section class="screen mood-diary-screen">
      <header class="top-bar"><button class="link-btn" data-go="welcome">←</button>
        <span>${esc(t(s, 'moodDiaryTitle'))}</span>
        <button class="link-btn" data-go="history">${esc(t(s, 'fullRecords'))}</button></header>
      <p class="muted">${esc(t(s, 'moodDiarySub'))}</p>
      <p class="caption">${esc(t(s, 'moodRetention'))}</p>
      <div class="diary-pages">${pages.length ? pages.map(p => `
        <div class="diary-page">
          <div class="page-date">${esc(p.dayStart)}</div>
          <div class="stickers">${p.stickers.length ? p.stickers.map(st => `
            <span class="sticker tag-${st.tagStyle}">${st.emoji} <small>${esc(st.tagLabel)}</small></span>`).join('') : `<span class="muted">${esc(t(s, 'moodEmpty'))}</span>`}</div>
          ${p.snippet ? `<p class="snippet">"${esc(p.snippet)}"</p>` : ''}
        </div>`).join('') : `<div class="empty">${esc(t(s, 'moodEmpty'))}</div>`}
      </div>
    </section>`;
  bindNav(root);
}

function renderAbout() {
  const s = state.lang;
  root.innerHTML = `
    <section class="screen about-screen">
      <header class="top-bar"><button class="link-btn" data-go="welcome">←</button><span>${esc(t(s, 'aboutTitle'))}</span></header>
      <span class="badge-green">${esc(t(s, 'aboutBadge'))}</span>
      <h2>${esc(t(s, 'appName'))}</h2>
      <p>一个安静的情绪日记——记录每天的心情，让那些说不出口的话，被温柔接住。</p>
      <h3>本地话术引擎</h3>
      <ul class="check-list">
        <li>✓ 479 个场景话术模板（从 iOS 版同步）</li>
        <li>✓ 关键词情绪规则离线识别</li>
        <li>✓ 数据保存在浏览器本地</li>
        <li>✓ 霸凌/高敏感场景纯安抚</li>
      </ul>
      <p class="muted">Web 版使用与 iOS 相同的本地话术库，不上传日记数据。</p>
    </section>`;
  bindNav(root);
}

function renderDemo() {
  const s = state.lang;
  root.innerHTML = `
    <section class="screen demo-screen">
      <header class="top-bar"><button class="link-btn" data-go="welcome">←</button><span>${esc(t(s, 'aiDemoTitle'))}</span></header>
      <p class="caption">本地话术引擎 · 关键词规则</p>
      <textarea id="demoInput">${s === 'en' ? 'Someone took my bag without asking' : '今天过的有点生气，因为有人偷拿了我的游泳包'}</textarea>
      <button class="btn-primary" id="demoBtn">分析</button>
      <pre id="demoOut" class="code-block">等待输入…</pre>
    </section>`;
  root.querySelector('#demoBtn').onclick = async () => {
    const text = root.querySelector('#demoInput').value;
    const r = await analyze(text);
    root.querySelector('#demoOut').textContent = demoJSON(r, s);
  };
  bindNav(root);
}

function bindNav(el) {
  el.querySelectorAll('[data-go]').forEach(btn => {
    btn.onclick = () => nav(btn.dataset.go);
  });
}

function render() {
  switch (state.screen) {
    case 'lang': return renderLang();
    case 'welcome': return renderWelcome();
    case 'diary': return renderDiary();
    case 'mood': return renderMood();
    case 'chat': return renderChat();
    case 'summary': return renderSummary();
    case 'history': return renderHistory();
    case 'moodDiary': return renderMoodDiary();
    case 'about': return renderAbout();
    case 'demo': return renderDemo();
    default: return renderWelcome();
  }
}

async function init() {
  await loadScenarios();
  state.screen = storage.langGatePassed() ? 'welcome' : 'lang';
  render();
}

init();
