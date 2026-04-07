<%@ page contentType="text/html;charset=UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 – Page Not Found | AeroSphere</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700;800;900&display=swap" rel="stylesheet">
    <script>(function(){var t=localStorage.getItem('aerosphere-theme')||(window.matchMedia('(prefers-color-scheme: dark)').matches?'dark':'light');document.documentElement.setAttribute('data-theme',t);})();</script>
    <style>
        :root{--primary:#10B981;--primary-glow:rgba(16,185,129,.18);--bg:#FAFAF9;--card-bg:#fff;--text:#1C1917;--text-muted:#6B7280;--border:#E5E7EB;}
        [data-theme="dark"]{--bg:#0A0A0A;--card-bg:#141414;--text:#F5F5F4;--text-muted:#9CA3AF;--border:#262626;}
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:'Inter',sans-serif;background:var(--bg);color:var(--text);min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;}
        .card{text-align:center;max-width:420px;padding:52px 40px;background:var(--card-bg);border:1px solid var(--border);border-radius:20px;box-shadow:0 12px 40px rgba(0,0,0,.08);}
        .err-code{font-size:7rem;font-weight:900;color:var(--primary);line-height:1;letter-spacing:-4px;}
        .err-title{font-size:1.4rem;font-weight:800;margin:12px 0 10px;}
        .err-desc{color:var(--text-muted);font-size:.9rem;line-height:1.6;margin-bottom:28px;}
        .btn{display:inline-flex;align-items:center;gap:8px;padding:12px 24px;background:var(--primary);color:#fff;border-radius:10px;text-decoration:none;font-weight:700;font-size:.9rem;transition:all .2s;}
        .btn:hover{opacity:.88;transform:translateY(-1px);}
        .btn-ghost{margin-top:12px;background:transparent;border:1px solid var(--border);color:var(--text);}
        .btn-ghost:hover{border-color:var(--primary);color:var(--primary);background:var(--primary-glow);}
        .actions{display:flex;gap:10px;justify-content:center;flex-wrap:wrap;}
    </style>
</head>
<body>
<div class="card">
    <div class="err-code">404</div>
    <div class="err-title">Page Not Found</div>
    <p class="err-desc">The page you're looking for doesn't exist or has been moved. Let's get you back on track.</p>
    <div class="actions">
        <a href="${pageContext.request.contextPath}/" class="btn">✈ Back to Home</a>
        <a href="javascript:history.back()" class="btn btn-ghost">← Go Back</a>
    </div>
</div>
</body>
</html>
