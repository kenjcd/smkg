<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Login • School Portal</title>
  <style>
    :root{
      --bg:#0b1220;
      --card:#101b33;
      --text:#eaf0ff;
      --muted:#aab7df;
      --line:rgba(255,255,255,.10);
      --accent:#7dd3fc;
      --accent2:#a78bfa;
      --bad:#fb7185;
      --shadow: 0 12px 40px rgba(0,0,0,.40);
      --radius: 18px;
    }
    *{box-sizing:border-box}
    body{
      margin:0;
      font-family: system-ui, -apple-system, Segoe UI, Roboto, Helvetica, Arial;
      background: radial-gradient(1200px 800px at 10% 10%, rgba(125,211,252,.15), transparent 60%),
                  radial-gradient(1000px 700px at 90% 0%, rgba(167,139,250,.12), transparent 55%),
                  var(--bg);
      color:var(--text);
      min-height:100vh;
      display:grid;
      place-items:center;
      padding:18px;
    }
    .card{
      width:min(460px, 100%);
      border:1px solid var(--line);
      border-radius: var(--radius);
      background: linear-gradient(180deg, rgba(16,27,51,.85), rgba(15,24,48,.65));
      box-shadow: var(--shadow);
      padding:18px 16px;
    }
    .brand{display:flex;align-items:center;gap:12px;margin-bottom:10px}
    .logo{
      width:42px;height:42px;border-radius:14px;
      background: linear-gradient(135deg, rgba(125,211,252,.9), rgba(167,139,250,.9));
      display:grid;place-items:center;font-weight:900;color:#071023;
    }
    h1{margin:0;font-size:16px}
    p{margin:6px 0 0;color:var(--muted);line-height:1.45;font-size:13px}
    form{margin-top:14px;display:grid;gap:10px}
    label{font-size:12px;color:var(--muted)}
    input{
      width:100%;
      padding:11px 12px;
      border-radius: 12px;
      border:1px solid rgba(255,255,255,.12);
      background: rgba(255,255,255,.06);
      color: var(--text);
      outline:none;
    }
    input:focus{border-color: rgba(125,211,252,.45)}
    .row{display:grid;gap:6px}
    .btn{
      cursor:pointer;
      border:1px solid rgba(125,211,252,.35);
      background: rgba(125,211,252,.12);
      color: var(--text);
      padding:11px 12px;
      border-radius: 12px;
      font-weight:800;
      transition: transform .12s ease, background .12s ease;
      display:inline-flex;align-items:center;justify-content:center;gap:8px;
    }
    .btn:hover{transform: translateY(-1px); background: rgba(125,211,252,.16)}
    .btn.secondary{
      border-color: rgba(255,255,255,.14);
      background: rgba(255,255,255,.06);
      font-weight:700;
    }
    .actions{display:flex;gap:10px;flex-wrap:wrap}
    .msg{
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
    .msg.error{
      border-color: rgba(251,113,133,.35);
      background: rgba(251,113,133,.10);
      color: #ffd0d7;
    }
    .small{font-size:12px}
    a{color: var(--accent); text-decoration:none}
    a:hover{text-decoration:underline}
  </style>
</head>

<body>
  <div class="card">
    <div class="brand">
      <div class="logo">SP</div>
      <div>
        <h1>School Portal Login</h1>
        <p>Use your email & password. After login you’ll be redirected to your allowed modules.</p>
      </div>
    </div>

    <form id="loginForm">
      <div class="row">
        <label for="email">Email</label>
        <input id="email" type="email" autocomplete="username" required placeholder="name@school.edu" />
      </div>

      <div class="row">
        <label for="password">Password</label>
        <input id="password" type="password" autocomplete="current-password" required placeholder="••••••••" />
      </div>

      <div class="actions">
        <button class="btn" type="submit">🔐 Sign In</button>
        <a class="btn secondary" href="/index.html">← Back</a>
      </div>

      <div id="msg" class="msg"></div>
      <p class="small">
        <span class="muted">Tip:</span> If you can login but see no modules, your roles are not set yet.
      </p>
    </form>
  </div>

  <script type="module">
    import { initializeApp } from "https://www.gstatic.com/firebasejs/10.12.5/firebase-app.js";
    import {
      getAuth,
      signInWithEmailAndPassword,
      onAuthStateChanged
    } from "https://www.gstatic.com/firebasejs/10.12.5/firebase-auth.js";

    /***********************
     * 1) PUT YOUR CONFIG HERE
     ***********************/
    const firebaseConfig = {
      apiKey: "PASTE_YOUR_API_KEY",
      authDomain: "PASTE_YOUR_PROJECT.firebaseapp.com",
      projectId: "PASTE_YOUR_PROJECT_ID",
      appId: "PASTE_YOUR_APP_ID"
    };

    const app = initializeApp(firebaseConfig);
    const auth = getAuth(app);

    const el = (id) => document.getElementById(id);
    const msg = el("msg");

    function showMsg(text, type){
      msg.textContent = text;
      msg.className = "msg" + (type === "error" ? " error" : "");
      msg.style.display = "block";
    }
    function hideMsg(){
      msg.style.display = "none";
    }

    // If already logged in, go straight to index (or app)
    onAuthStateChanged(auth, (user) => {
      if (user) window.location.href = "/index.html";
    });

    el("loginForm").addEventListener("submit", async (e) => {
      e.preventDefault();
      hideMsg();

      const email = el("email").value.trim();
      const password = el("password").value;

      try{
        await signInWithEmailAndPassword(auth, email, password);

        // After login: go index; index will show only allowed modules.
        window.location.href = "/index.html";
      }catch(err){
        // Friendly errors
        const code = (err && err.code) ? err.code : "";
        let text = "Login failed. Please try again.";
        if (code.includes("auth/invalid-credential")) text = "Wrong email or password.";
        if (code.includes("auth/user-not-found")) text = "No user found for that email.";
        if (code.includes("auth/wrong-password")) text = "Wrong password.";
        if (code.includes("auth/too-many-requests")) text = "Too many attempts. Try again later.";
        showMsg(text, "error");
      }
    });
  </script>
</body>
</html>
