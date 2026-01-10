<!-- public/app.html -->
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>App • School Portal</title>
  <meta name="description" content="Protected app shell (Firebase Auth + Roles)" />
  <style>
    :root{
      --bg:#0b1220;
      --card:#101b33;
      --card2:#0f1830;
      --text:#eaf0ff;
      --muted:#aab7df;
      --line:rgba(255,255,255,.08);
      --accent:#7dd3fc;
      --accent2:#a78bfa;
      --good:#34d399;
      --warn:#fbbf24;
      --bad:#fb7185;
      --shadow: 0 10px 30px rgba(0,0,0,.35);
      --radius: 18px;
    }
    *{box-sizing:border-box}
    body{
      margin:0;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial, "Apple Color Emoji","Segoe UI Emoji";
      background: radial-gradient(1200px 800px at 10% 10%, rgba(125,211,252,.15), transparent 60%),
                  radial-gradient(1000px 700px at 90% 0%, rgba(167,139,250,.12), transparent 55%),
                  var(--bg);
      color:var(--text);
      min-height:100vh;
    }
    .wrap{max-width:1100px;margin:0 auto;padding:28px 18px 60px}
    .topbar{
      display:flex;gap:12px;align-items:center;justify-content:space-between;
      padding:14px 16px;border:1px solid var(--line);border-radius: var(--radius);
      background: linear-gradient(180deg, rgba(16,27,51,.9), rgba(15,24,48,.7));
      box-shadow: var(--shadow);
      backdrop-filter: blur(8px);
      position: sticky; top: 12px; z-index: 10;
    }
    .brand{display:flex;align-items:center;gap:12px}
    .logo{
      width:38px;height:38px;border-radius:12px;
      background: linear-gradient(135deg, rgba(125,211,252,.9), rgba(167,139,250,.9));
      display:grid;place-items:center;font-weight:900;color:#071023;
      box-shadow: 0 10px 20px rgba(0,0,0,.25);
    }
    .brand h1{margin:0;font-size:15px;letter-spacing:.3px}
    .brand p{margin:2px 0 0;color:var(--muted);font-size:12px}
    .actions{display:flex;align-items:center;gap:10px;flex-wrap:wrap}
    .chip{
      border:1px solid var(--line);
      background: rgba(255,255,255,.04);
      padding:8px 10px;border-radius:999px;
      font-size:12px;color:var(--muted);
      display:flex;align-items:center;gap:8px;
    }
    .btn{
      cursor:pointer;
      border:1px solid var(--line);
      background: rgba(255,255,255,.06);
      color:var(--text);
      padding:9px 12px;
      border-radius:12px;
      font-weight:600;
      transition: transform .12s ease, background .12s ease, border-color .12s ease;
      text-decoration:none;
      display:inline-flex;align-items:center;gap:8px;
    }
    .btn:hover{transform: translateY(-1px); background: rgba(255,255,255,.09); border-color: rgba(255,255,255,.18)}
    .btn.primary{
      border-color: rgba(125,211,252,.35);
      background: rgba(125,211,252,.12);
    }
    .btn.danger{
      border-color: rgba(251,113,133,.35);
      background: rgba(251,113,133,.10);
    }

    .panel{
      margin-top:18px;
      border:1px solid var(--line);
      border-radius: var(--radius);
      background: linear-gradient(180deg, rgba(16,27,51,.6), rgba(15,24,48,.35));
      padding:18px 16px;
      box-shadow: var(--shadow);
    }
    .panel h2{margin:0;font-size:18px}
    .panel p{margin:6px 0 0;color:var(--muted);line-height:1.45}

    .tabs{
      margin-top:14px;
      display:flex;gap:10px;flex-wrap:wrap;
    }
    .tab{
      border:1px solid var(--line);
      background: rgba(255,255,255,.04);
      color:var(--text);
      padding:8px 10px;
      border-radius: 999px;
      font-size:12px;
      cursor:pointer;
      user-select:none;
      display:inline-flex;align-items:center;gap:8px;
      transition: transform .12s ease, background .12s ease, border-color .12s ease;
    }
    .tab:hover{transform: translateY(-1px); background: rgba(255,255,255,.07); border-color: rgba(255,255,255,.16)}
    .tab.active{
      border-color: rgba(125,211,252,.35);
      background: rgba(125,211,252,.12);
    }
    .tab.locked{
      border-color: rgba(251,191,36,.25);
      background: rgba(251,191,36,.08);
      opacity:.7;
      cursor:not-allowed;
    }

    .content{
      margin-top:14px;
      border:1px dashed rgba(255,255,255,.12);
      border-radius: var(--radius);
      padding:14px;
      background: rgba(0,0,0,.12);
    }
    .status{
      margin-top:10px;
      padding:10px 12px;
      border-radius: 14px;
      border:1px solid rgba(255,255,255,.10);
      background: rgba(255,255,255,.05);
      color: var(--muted);
      font-size:12.5px;
      line-height:1.45;
      display:none;
    }
    .status.ok{
      border-color: rgba(52,211,153,.35);
      background: rgba(52,211,153,.10);
      color: #b7f7dc;
    }
    .status.err{
      border-color: rgba(251,113,133,.35);
      background: rgba(251,113,133,.10);
      color: #ffd0d7;
    }
    .hidden{display:none !important}
    .muted{color:var(--muted)}
    code{font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace}
  </style>
</head>

<body>
  <div class="wrap">
    <div class="topbar">
      <div class="brand">
        <div class="logo">SP</div>
        <div>
          <h1 id="appTitle">App</h1>
          <p id="subText">Checking access…</p>
        </div>
      </div>
      <div class="actions">
        <div class="chip" id="userChip">
          <span>👤</span>
          <span class="muted" id="userText">—</span>
        </div>

        <a class="btn" href="/index.html">🏠 Home</a>
        <button class="btn danger" id="btnLogout" type="button">🚪 Logout</button>
      </div>
    </div>

    <div class="panel">
      <h2 id="moduleHeading">Loading module…</h2>
      <p id="moduleDesc">Please wait.</p>

      <div class="tabs" id="tabs"></div>

      <div class="status" id="statusBox"></div>

      <div class="content" id="contentBox">
        <div class="muted">
          This is a protected shell. Replace the placeholder module content with your real pages/components.
        </div>
      </div>
    </div>
  </div>

  <script type="module">
    import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.5/firebase-app.js";
    import {
      getAuth,
      onAuthStateChanged,
      signOut
    } from "https://www.gstatic.com/firebasejs/10.12.5/firebase-auth.js";

    // OPTIONAL Firestore fallback for roles (same as index)
    import {
      getFirestore,
      doc,
      getDoc
    } from "https://www.gstatic.com/firebasejs/10.12.5/firebase-firestore.js";

    /***********************
     * 1) PUT YOUR CONFIG HERE
     ***********************/
    const firebaseConfig = {
      apiKey: "AIzaSyDVcU-r88-q57FgZsK0xwsY2oXlRagxZf8",
      authDomain: "dashboard-smkg.firebaseapp.com",
      projectId: "dashboard-smkg",
      appId: "1:725047177734:web:53ceaeed2dd9b3da85c987"
    };

    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);
    const db = getFirestore(app);

    /***********************
     * 2) MODULE DEFINITIONS
     ***********************/
    const MODULES = [
      {
        key: "akademik",
        title: "Akademik",
        desc: "Pengurusan kurikulum & bilik darjah.",
        icon: "🎓",
        requiredAnyRole: ["admin", "akademik"]
      },
      {
        key: "mmi",
        title: "MMI",
        desc: "Memaksimakan Masa Instruktional.",
        icon: "👥",
        requiredAnyRole: ["admin", "mmi"]
      },
      {
        key: "gc",
        title: "Guru Cemerlang",
        desc: "Menginspirasi Generasi, Mencipta Masa Depan.",
        icon: "🏆",
        requiredAnyRole: ["admin", "gc"]
      }
    ];

    const el = (id) => document.getElementById(id);
    const statusBox = el("statusBox");
    const tabs = el("tabs");
    const contentBox = el("contentBox");

    function showStatus(text, type){
      statusBox.textContent = text;
      statusBox.className = "status " + (type === "ok" ? "ok" : type === "err" ? "err" : "");
      statusBox.style.display = "block";
    }
    function hideStatus(){
      statusBox.style.display = "none";
    }

    function getQueryParam(name){
      const url = new URL(window.location.href);
      return url.searchParams.get(name);
    }

    function moduleUrl(key){
      return `/app.html?module=${encodeURIComponent(key)}`;
    }

    function hasAnyRole(userRoles, requiredAnyRole){
      if (!requiredAnyRole || !requiredAnyRole.length) return true;
      const s = new Set(userRoles);
      return requiredAnyRole.some(r => s.has(r));
    }

    async function getRolesForUser(user){
      const tokenResult = await user.getIdTokenResult(true);
      const claims = tokenResult.claims || {};
      let roles = [];

      if (Array.isArray(claims.roles)) roles = claims.roles.slice();
      else if (typeof claims.role === "string") roles = [claims.role];

      ["admin","akademik","mmi","gc"].forEach(r => {
        if (claims[r] === true && !roles.includes(r)) roles.push(r);
      });

      // OPTIONAL Firestore fallback:
      if (!roles.length){
        try{
          const snap = await getDoc(doc(db, "users", user.uid));
          if (snap.exists()){
            const data = snap.data() || {};
            if (Array.isArray(data.roles)) roles = data.roles.slice();
          }
        }catch(err){}
      }
      return roles;
    }

    function getModuleDef(key){
      return MODULES.find(m => m.key === key) || null;
    }

    function renderTabs(currentKey, roles){
      tabs.innerHTML = "";

      MODULES.forEach(m => {
        const allowed = hasAnyRole(roles, m.requiredAnyRole);
        const b = document.createElement("div");
        b.className = "tab" +
          (m.key === currentKey ? " active" : "") +
          (!allowed ? " locked" : "");

        b.innerHTML = `${m.icon} ${m.title}`;

        if (allowed){
          b.addEventListener("click", () => {
            window.location.href = moduleUrl(m.key);
          });
        }else{
          b.title = "No access";
        }
        tabs.appendChild(b);
      });
    }

    function renderModulePlaceholder(m){
      // Replace this part with real pages/components later.
      contentBox.innerHTML = `
        <div style="display:grid;gap:10px">
          <div style="font-weight:900;font-size:14px">Module Loaded: ${m.icon} ${m.title}</div>
          <div class="muted" style="line-height:1.5">
            This is a placeholder content area for <b>${m.key}</b>.
            Next step: we can replace this with your real HTML sections, or load separate module files.
          </div>

          <div class="muted" style="font-size:12.5px">
            Tip: If you want separate module pages, we can do <code>/modules/akademik.html</code> and fetch+inject it here.
          </div>
        </div>
      `;
    }

    function denyAccess(moduleKey){
      el("subText").textContent = "Access denied.";
      el("moduleHeading").textContent = "🚫 Access denied";
      el("moduleDesc").textContent =
        `You do not have permission to access: ${moduleKey ? moduleKey : "(unknown)"}.`;

      contentBox.innerHTML = `
        <div style="display:grid;gap:10px">
          <div style="font-weight:900">You’re logged in, but not allowed for this module.</div>
          <div class="muted">
            Go back to <a href="/index.html" style="color:var(--accent)">Home</a>.
          </div>
        </div>
      `;

      showStatus("Denied: module not permitted by your roles.", "err");
    }

    function bounceToLogin(){
      // Keep where user tried to go
      const here = window.location.pathname + window.location.search;
      window.location.href = `/login.html?next=${encodeURIComponent(here)}`;
    }

    el("btnLogout").addEventListener("click", async () => {
      await signOut(auth);
      window.location.href = "/login.html";
    });

    /***********************
     * 3) MAIN: Guard + render
     ***********************/
    onAuthStateChanged(auth, async (user) => {
      hideStatus();

      const moduleKey = (getQueryParam("module") || "").toLowerCase().trim();
      const moduleDef = getModuleDef(moduleKey) || MODULES[0];

      if (!user){
        // Not logged in => bounce
        bounceToLogin();
        return;
      }

      el("userText").textContent = user.email || "Signed in";
      el("appTitle").textContent = "App";
      el("subText").textContent = "Checking roles…";

      const roles = await getRolesForUser(user);

      // render tabs early (shows locked vs allowed)
      renderTabs(moduleDef.key, roles);

      // enforce access
      const allowed = hasAnyRole(roles, moduleDef.requiredAnyRole);
      if (!allowed){
        denyAccess(moduleDef.key);
        return;
      }

      // allowed
      el("subText").textContent = "Access granted.";
      el("moduleHeading").textContent = `${moduleDef.icon} ${moduleDef.title}`;
      el("moduleDesc").textContent = moduleDef.desc;
      showStatus(`Allowed. Your roles: ${roles.length ? roles.join(", ") : "(none)"}`, "ok");
      renderModulePlaceholder(moduleDef);
    });
  </script>
</body>
</html>
