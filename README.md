# ✈️ AeroSphere — Airline Booking System

A production-ready Java web application (JSP + Servlets) for airline flight booking, payments (Razorpay), PDF invoicing, and admin management.

---

## 🗂️ Project Structure

```
skyconnect-airline/
├── src/main/
│   ├── java/com/skyconnect/
│   │   ├── controller/     # 40 HTTP Servlets (login, booking, payment, admin…)
│   │   ├── dao/            # Data Access Layer (JDBC)
│   │   ├── model/          # POJOs (User, Flight, Booking, Passenger…)
│   │   ├── service/        # EmailService, PdfInvoiceService
│   │   └── util/           # DBConnection, AppConfig, CsrfUtil, HtmlUtils
│   └── webapp/
│       ├── META-INF/context.xml   # Tomcat config (env vars override all)
│       ├── WEB-INF/web.xml        # Servlet config, error pages, sessions
│       ├── Views/                 # JSP pages (admin/, auth/, user/, common/)
│       └── assests/               # CSS, JS
├── docker/
│   ├── mysql/init.sql      # DB schema + seed data (auto-imported)
│   └── tomcat/server.xml   # Hardened Tomcat config
├── .github/workflows/
│   └── deploy.yml          # GitHub Actions CI/CD
├── Dockerfile              # Multi-stage build (Maven → Tomcat 9)
├── docker-compose.yml      # nginx + app + mysql
├── nginx.conf              # Reverse proxy + security headers
├── .env                    # Runtime secrets (gitignored)
├── .env.example            # Template (safe to commit)
└── pom.xml                 # Maven build
```

---

## 🚀 Quick Start (Docker)

### Prerequisites
- Docker 20.10+
- Docker Compose 2.0+

### 1. Clone & Configure
```bash
git clone <your-repo-url>
cd skyconnect-airline

# Create your environment file from the template
cp .env.example .env
# Edit .env with your real values (DB password, Razorpay keys, SMTP, etc.)
nano .env
```

### 2. Build & Run
```bash
docker-compose up --build
```

First run takes ~3–5 minutes (Maven downloads dependencies, MySQL initializes).

### 3. Access the App
| URL | Description |
|-----|-------------|
| http://localhost | App via Nginx (production path) |
| http://localhost:8080 | Direct Tomcat access (debug) |
| http://localhost/health | Health check endpoint |
| http://localhost:3307 | MySQL (from host machine) |

---

## 🔑 Default Credentials

After startup the DB is seeded with sample data. Admin login:

| Field | Value |
|-------|-------|
| Email | (any ADMIN role user from the DB) |
| Password | (as set during registration, hashed with BCrypt) |

Check the `users` table:
```bash
docker exec -it aerosphere_mysql mysql -u aerosphere -p airlinedb -e "SELECT email, role FROM users;"
```

---

## ⚙️ Environment Variables Reference

| Variable | Description | Default |
|----------|-------------|---------|
| `DB_URL` | JDBC connection URL | `jdbc:mysql://mysql:3306/airlinedb?...` |
| `DB_USER` | DB username | `aerosphere` |
| `DB_PASSWORD` | DB password | *(required)* |
| `RAZORPAY_KEY_ID` | Razorpay key ID | *(required for payments)* |
| `RAZORPAY_KEY_SECRET` | Razorpay secret | *(required for payments)* |
| `SMTP_HOST` | Mail server host | `smtp.gmail.com` |
| `SMTP_PORT` | Mail server port | `587` |
| `SMTP_USER` | Gmail address | *(required for emails)* |
| `SMTP_PASSWORD` | Gmail App Password | *(required for emails)* |
| `SMS_API_KEY` | Fast2SMS API key | *(required for OTP SMS)* |
| `APP_BASE_URL` | Public URL of app | `http://localhost` |

---

## 🏗️ Build Locally (without Docker)

```bash
# Requires: JDK 11+, Maven 3.6+, Tomcat 9, MySQL 8

mvn clean package -DskipTests
# → target/app.war

# Deploy to local Tomcat:
cp target/app.war $CATALINA_HOME/webapps/ROOT.war
```

---

## 🔄 CI/CD Pipeline

GitHub Actions workflow at `.github/workflows/deploy.yml`:

1. **Build** — Compiles Java, packages WAR
2. **Docker** — Builds image, pushes to Docker Hub (on `main` branch)
3. **Deploy** — SSH deploy to production server (optional, configure secrets)

### Required GitHub Secrets
```
DOCKERHUB_USERNAME
DOCKERHUB_TOKEN
DEPLOY_HOST        (optional, for SSH deploy)
DEPLOY_USER        (optional)
DEPLOY_SSH_KEY     (optional)
```

---

## 🛡️ Security Features

- **CSRF Protection** — Token-based per session
- **BCrypt Passwords** — All passwords hashed with salt
- **Session Fixation** — Session invalidated on login
- **HttpOnly Cookies** — XSS mitigation
- **Security Headers** — X-Frame-Options, X-Content-Type, XSS-Protection via Nginx
- **AJP Disabled** — Protects against Ghostcat (CVE-2020-1938)
- **Rate Limiting** — Nginx limits login attempts (5/min) and API calls (30/min)

---

## 🔧 Useful Commands

```bash
# View live logs
docker-compose logs -f app
docker-compose logs -f mysql

# Restart only the app (after code change)
docker-compose up --build app

# Connect to MySQL shell
docker exec -it aerosphere_mysql mysql -u aerosphere -pAeroSphere@2024 airlinedb

# Rebuild from scratch
docker-compose down -v && docker-compose up --build

# Check health
curl http://localhost/health
```
