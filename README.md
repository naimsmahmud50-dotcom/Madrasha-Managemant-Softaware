# 🕌 Madrasha Management Platform (মাদরাসা ম্যানেজমেন্ট ইকোসিস্টেম)

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart">
  <img src="https://img.shields.io/badge/NestJS-12.x-E0234E?logo=nestjs&logoColor=white" alt="NestJS">
  <img src="https://img.shields.io/badge/TypeScript-5.x-3178C6?logo=typescript&logoColor=white" alt="TypeScript">
  <img src="https://img.shields.io/badge/Firebase-Firestore-FFCA28?logo=firebase&logoColor=black" alt="Firebase">
  <img src="https://img.shields.io/badge/PostgreSQL-Multi--Tenant%20RLS-336791?logo=postgresql&logoColor=white" alt="PostgreSQL">
  <img src="https://img.shields.io/badge/Architecture-Clean%20%26%20Offline--First-success" alt="Architecture">
  <img src="https://img.shields.io/badge/Status-Production%20Ready-brightgreen" alt="Status">
</p>

---

## 📌 Overview (পরিচিতি)

**Madrasha Management Platform** is a modern, enterprise-grade, offline-first institutional management ecosystem purpose-built for Islamic educational institutions—supporting both **Qawmi** and **Alia** Madrasahs.

From specialized **Hifz progress tracking (Sabaq, Sabaqi, Ammokhta)** and multi-tier role dashboards to automated parent SMS/Push alerts and Shariah-compliant Zakat/Donation auditing, this platform bridges Islamic traditional values with contemporary software engineering.

---

## ✨ Core Pillars & Highlights (মূল বৈশিষ্ট্যসমূহ)

### 📖 1. Specialized Hifz-ul-Quran Tracker
- **Tri-Fold Quranic Assessment:** Daily tracking for **Sabaq** (new daily lesson), **Sabaqi** (recent revision within 1-5 Paras), and **Ammokhta** (cumulative revision of all completed Paras).
- **Evaluation Metrics:** Fluency, Tajweed precision, and memorization mistakes grading.
- **Guardian Visibility:** Real-time progress updates sent directly to parents' mobile dashboards.

### 🏫 2. Dual Curriculum Architecture (Qawmi & Alia)
- **Qawmi Stream:** Native support for stages: *Ibtidaa-ee, Mutawassitah, Sanawiyyah, Fadilat, and Takmil (Dawra-e-Hadith)*.
- **Alia Stream:** Standard board curriculum: *Class 6 through Class 10, Alim 1st Year, and Alim 2nd Year*.
- **Dynamic Configuration:** Switch institution type on-the-fly with tailored grading routines, class names, and subject sets.

### 👥 3. 4-Tier Role-Based Experience
| Role | Capabilities |
| :--- | :--- |
| **👑 Super Admin / Muhtamim** | Institutional oversight, user approval, staff payroll, tuition fees, Zakat fund auditing, and push notice broadcasting. |
| **👨‍🏫 Teacher / Ustad** | Fast roll-call attendance, Hifz Sabaq logging, exam marksheet entry, homework assignments, and leave processing. |
| **👨‍👩‍👦 Guardian / Wali** | Daily attendance monitoring, live Hifz progress, fee payment receipts, exam report cards, and teacher messaging. |
| **🎓 Student / Talib-e-Ilm** | Digital routine, academic results, LMS lecture notes, study materials, and hostel status. |

### 📲 4. Carrier-Grade SMS & Automation Cascade
- **Bangla Character Engine:** Automatic carrier standard calculation (70 chars per Unicode SMS vs 160 chars GSM-7).
- **Zero-Balance Auto-Fallback:** If SMS balance runs out, alerts automatically downgrade to free Firebase Cloud Messaging (FCM) Push Notifications so parents never miss an alert.
- **Quiet-Hours Bypass:** Critical hospital and emergency security alerts bypass quiet hours (10 PM – 6 AM Asia/Dhaka) instantly.

### 📶 5. Offline-First Resilience
- Built with local SQLite/Drift persistence.
- Record attendance, grades, and evaluations without internet connectivity; changes queue up and auto-sync to cloud when online.

---

## 🏗️ System Architecture (আর্কিটেকচার)

```mermaid
graph TD
  A[📱 Flutter Mobile App] -->|Offline-First / Riverpod| B(Local Drift SQLite DB)
  A -->|Direct Realtime Stream| C[(🔥 Cloud Firestore)]
  A -->|Secure Bearer JWT| D[⚡ Core API / NestJS]
  
  D -->|Multi-Tenant RLS| E[(🐘 PostgreSQL Database)]
  D -->|Task Queue / PubSub| F[(🔴 Redis & BullMQ)]
  D -->|Failover Cascade| G[🧠 AI Gateway<br/>Claude -> Gemini -> OpenAI]
  D -->|Multi-Gateway| H[✉️ SMS Engine<br/>Greenweb / SSL / Twilio]
```

---

## 🛡️ Enterprise Security & Privacy (নিরাপত্তা ও সুরক্ষা)

- **Zero-Trust Multi-Tenancy:** 25+ database tables enforce strict PostgreSQL Row-Level Security (`ENABLE ROW LEVEL SECURITY` and `FORCE ROW LEVEL SECURITY`).
- **Timing-Attack Proof:** Timing-safe HMAC-SHA256 signature verification in custom `JwtService` preventing signature-tampering and timing side-channel attacks.
- **PII Scrubbing:** Built-in regex engine redacts sensitive national identity numbers (NID/BRN) and personal phone numbers before AI prompts leave the server.
- **Scraper & Bot Shield:** Strict Firestore Security Rules deny unauthenticated reads and writes across all collection paths.
- **Release Security Gate:** Developer backdoors and debug tools are strictly gated behind Flutter's `kDebugMode` and eliminated in production binaries.

---

## 💻 Tech Stack (ব্যবহৃত প্রযুক্তি)

| Component | Technologies |
| :--- | :--- |
| **Mobile Frontend** | Flutter 3.x, Dart 3.x, Flutter Riverpod, Google Fonts |
| **Mobile Local DB** | SQLite, Drift, Shared Preferences |
| **Cloud Services** | Firebase Auth, Cloud Firestore (Offline Persistence Enabled) |
| **Backend API** | NestJS 12, Node.js (ESM), TypeScript, Vitest |
| **Primary Database** | PostgreSQL / Supabase with Row Level Security (RLS) |
| **Worker & Cache** | Redis, BullMQ (Async report generation & notification dispatch) |
| **AI Gateway** | Anthropic Claude, Google Gemini, OpenAI |
| **DevOps & CI/CD** | GitHub Actions, Docker, Kubernetes Liveness/Readiness Probes |

---

## 📂 Project Structure (ফোল্ডার বিন্যাস)

```text
Madrasha Ecosystem/
├── 01_Backend/
│   └── core-api/               # NestJS Enterprise API
│       ├── src/
│       │   ├── modules/        # Academic, Auth, Finance, Hifz, Attendance, AI Gateway
│       │   ├── common/         # JWT service, Guards, Interceptors, Decorators
│       │   └── app.module.ts
│       └── test/               # Vitest Unit & Integration Suites
│
├── 02_ Mobile/
│   └── madrasah_app/           # Flutter Mobile Application
│       ├── lib/
│       │   ├── core/           # Themes, Widgets, Sync Engine, Providers
│       │   ├── features/       # Academic, Attendance, Auth, Dashboard, Finance, Hifz
│       │   └── main.dart
│       ├── firestore.rules     # Cloud Firestore Security Rules
│       └── test/               # Widget & Unit Tests
│
├── 04_Database/
│   └── migrations/             # PostgreSQL Schema Migrations (001 to 008)
│
├── dist-apk/                   # Compiled Android Application Packages (Debug & Release)
└── scripts/                    # Tenant RLS Security & Verification Shell Scripts
```

---

## 🚀 Getting Started (রান করার নির্দেশিকা)

### Prerequisites (পূর্বশর্ত)
- **Flutter SDK:** `>= 3.24.0`
- **Node.js:** `>= 20.x` & `pnpm`
- **PostgreSQL:** `>= 15.x`

### 1. Mobile App Setup (মোবাইল অ্যাপ)
```bash
# Navigate to mobile project
cd "02_ Mobile/madrasah_app"

# Install Flutter dependencies
flutter pub get

# Run static code analysis
flutter analyze

# Run unit & widget tests
flutter test

# Run app in development mode
flutter run
```

### 2. Backend Setup (ব্যাকএন্ড এপিআই)
```bash
# Navigate to backend directory
cd "01_Backend/core-api"

# Install dependencies
pnpm install

# Run Vitest test suite
pnpm run test

# Compile production build
pnpm run build

# Start development server
pnpm run start:dev
```

---

## ⚙️ Environment Configuration (এনভায়রনমেন্ট কনফিগারেশন)

Create a `.env` file in `01_Backend/core-api/` based on the template below:

```env
# Application
PORT=3000
NODE_ENV=production

# Security & JWT
JWT_SECRET=your_super_secret_hmac_sha256_key_here
JWT_EXPIRATION=86400

# Database (PostgreSQL / Supabase)
DATABASE_URL=postgresql://user:password@localhost:5432/madrasha_db

# Redis / Queue
REDIS_HOST=localhost
REDIS_PORT=6379

# AI Gateway (Fallback Cascade)
ANTHROPIC_API_KEY=your_claude_api_key
GEMINI_API_KEY=your_gemini_api_key
OPENAI_API_KEY=your_openai_api_key

# SMS Gateways
GREENWEB_TOKEN=your_primary_sms_token
SSL_WIRELESS_API_KEY=your_backup_sms_key
```

> [!NOTE]  
> Never commit `.env`, private service keys, or Firebase tokens to version control.

---

## 🧪 Verification & Test Coverage (টেস্টিং ফলাফল)

- **Backend API:** `49 / 49 tests passed (100% Pass Rate)` across JWT cryptography, AI gateway rate-limiting, and carrier multi-part SMS logic.
- **Mobile Client:** `flutter analyze` reports `0 issues found`.
- **Database Isolation:** `25 / 25 tables passed` strict PostgreSQL Row Level Security audit.

---

## 📜 License & Copyright (লাইসেন্স)

Developed with ❤️ for Islamic Educational Institutions.  
Proprietary & Confidential © 2026 Madrasha Ecosystem. All Rights Reserved.
