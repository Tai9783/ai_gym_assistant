# AI Gym Assistant

**AI Gym Assistant** is a Flutter fitness application for planning workouts, recording actual exercise performance, and tracking progress over time. It supports both **AI-assisted recommendations** and **fully manual workout planning**, with workout data stored locally using Drift/SQLite.

The project combines a feature-first, Clean Architecture-inspired Flutter codebase with a small **Cloudflare Workers backend** that securely connects to the Google Gemini API.

> **Project type:** Personal / Flutter portfolio project. It demonstrates mobile architecture, local persistence, workout business logic, progress analytics, and serverless AI integration. It is not a medical or professional fitness coaching service.

## Features

### 1. AI-Assisted Workout Recommendations

- Choose a workout focus (chest, back, legs, shoulders, arms, or full body), optionally select specific exercises, and add a note. The seeded catalog includes exercises specifically categorized as Full Body.
- Build an **AI Context** from the workout request, exercise catalog, optional user profile, and available recent/long-term exercise progress.
- Request suggested exercises, sets, repetitions, and weights from Gemini **through a Cloudflare Worker**, rather than calling Gemini directly from Flutter.
- Use a structured JSON response schema and validate the generated plan against allowed exercise IDs and set constraints before presenting it to the user.
- When exercises are explicitly selected, the recommendation must use that selection rather than silently adding or removing exercises.

### 2. Manual Workout Planning

- Select exercises and configure target sets, weights, and repetitions without generating an AI recommendation.
- Convert manual and AI-generated plans into the same `WorkoutExercise` / `ExerciseSet` domain structure.
- Use a shared workout execution, persistence, and history flow regardless of how a workout was created.

### 3. Workout Tracking and Resume

- Record **suggested vs. actual** weight and repetitions for each set.
- Explicitly mark individual sets as completed; completed results are persisted to local SQLite during the workout.
- Resume an unfinished workout with previously saved exercises and set results.
- Prevent starting another workout while a session remains `inProgress`.
- Finish or cancel a workout; cancelled sessions are excluded from completed workout history and progress analysis.

### 4. History and Progress Analytics

- Browse completed workouts and review individual exercise/set results. History and Progress refresh when users return to their tabs.
- View **Recent Progress** for up to the last five exercise sessions, including target-hit rates, missed-target streaks, recent weights, and weight/volume trends.
- View **Long-Term Progress** across completed exercise history, including total sessions, best recorded weight, target-hit rates, and long-term trends.
- Calculate trends from chronological performance data using early/late averages and configurable percentage thresholds rather than only comparing the first and last values.
- Display a **recent weight chart** with up to five sessions per exercise, showing recorded weights over time.

### 5. Versioned Local Progress Cache

- Store derived progress results in the `ExerciseProgressCaches` table, separately from the original workout history.
- Preserve a recent summary window (up to five sessions) and long-term aggregate state for efficient incremental updates after completed workouts.
- Detect stale, incompatible, or invalid cache data and **rebuild from completed workout history** when needed.
- Keep the cache calculation version centralized so algorithm changes can invalidate older computed results without deleting the original sessions.

### 6. Firebase-Authenticated AI Backend

- Use **Firebase Anonymous Authentication** to obtain a user identity and ID token for AI requests.
- Verify Firebase ID tokens in the Cloudflare Worker before accepting recommendation requests.
- Keep the Gemini API key in a **Cloudflare Worker Secret**, not in Flutter code or a `--dart-define` value.
- Use Cloudflare D1 to enforce per-user request limits and cooldowns.
- Handle authentication failures, invalid requests, rate limits, and upstream AI failures; the manual workout flow remains independent of Gemini requests.

## Tech Stack

**Flutter SDK:** `3.44.0` (pinned in `.fvmrc`) · **Dart SDK constraint:** `^3.11.1` (in `pubspec.yaml`)

| Area | Technologies / versions declared in `pubspec.yaml` |
|---|---|
| Mobile | Flutter, Dart |
| Architecture | Feature-first; Clean Architecture-inspired Domain / Data / Presentation layering |
| State management | `flutter_bloc: ^9.1.1`, `equatable: ^3.0.0` |
| Local persistence | `drift: ^2.35.2`, `drift_flutter: ^0.3.1`, SQLite |
| Dependency injection | `get_it: ^9.3.0`, `injectable: ^3.0.0` |
| Navigation | `go_router: ^18.1.0` (`StatefulShellRoute.indexedStack`) |
| Networking & identifiers | `http: ^1.6.0`, `uuid: ^4.6.0` |
| Firebase | `firebase_core: ^5.0.0`, `firebase_auth: ^7.0.0` (anonymous authentication) |
| UI / assets | `flutter_svg: ^2.3.0`, local exercise and muscle-group images |
| AI integration | Google Gemini API; structured JSON output and client-side validation |
| Serverless backend | JavaScript, Cloudflare Workers, Cloudflare D1 |
| Testing & code generation | `flutter_test`, `mocktail: ^1.0.5`, `drift_dev`, `build_runner`, `injectable_generator` |

> Package numbers above are **version constraints**, not necessarily the exact versions resolved in `pubspec.lock`.

## Architecture

The Flutter project is organized **by feature**, with Domain, Data, and Presentation layers. Domain entities and use cases hold business rules; Data implements persistence and remote requests; Presentation manages BLoC/Cubit state and UI.

```text
lib/
├── app/                         # Navigation, shared pages, theme, utilities
├── core/
│   ├── auth/                    # Firebase anonymous sign-in abstraction
│   ├── database/                # Drift database and table definitions
│   └── di/                      # GetIt / Injectable configuration
└── features/
    ├── exercise_catalog/        # Seeded catalog (13 exercises, 6 focus groups)
    ├── recommendation/          # AI context, Gemini API client, validation
    ├── workout/                 # Manual planning, session lifecycle, resume
    ├── history/                 # Completed workout browsing
    ├── progress/                # Recent/long-term analytics, cache, 5-session chart
    └── profile/                 # Locally stored fitness profile

backend/
└── cloudflare-worker/
    ├── src/index.js             # Auth, validation, D1 limits, Gemini request
    ├── migrations/              # D1 schema for per-user usage tracking
    └── README.md                # Backend details and deployment notes
```

### Workout Lifecycle

```text
          AI Recommendation                Manual Workout
          (Gemini-backed)                  (local setup)
                 \                              /
                  \                            /
                   v                          v
                      List<WorkoutExercise>
                                |
                                v
                          StartWorkout
                                |
                         session: inProgress
                                |
                    UpdateExerciseSet (save to SQLite)
                                |
                      +---------+---------+
                      |                   |
                      v                   v
                 Resume Workout      Finish / Cancel
                                          |
                           +--------------+--------------+
                           |                             |
                        completed                      cancelled
                           |                             |
                 History + Progress Cache       Excluded from completed
                           |                    History / Progress
                        Progress UI
```

### Progress Data Flow

Raw workout sessions, exercises, and sets are the **source of truth**. Progress data is derived from completed sessions, not independently entered by users.

```text
Completed Workout (Drift/SQLite)
        |
        v
ExerciseSessionSummarizer
        |
        +--> RecentProgressAnalyzer   --> Recent Progress (last 5)
        |           |
        |           +--> Recent Window --> Weight Chart
        |
        +--> LongTermProgressAnalyzer --> Long-Term Progress
                    |
                    v
             ProgressTrendCalculator (shared by Recent and Long-Term)

After FinishWorkout: incremental cache synchronization when safe
On Progress read: validate cache -> reuse or rebuild from history
```

The same computed progress information can be used in the Progress screen and in the AI Context for future recommendations. The weight chart reads recent session summaries; it does not require another Gemini request.

### AI Recommendation Request Flow

```text
Flutter
  WorkoutRequest + Profile + Exercise Progress
       |
       v
  PrepareAiContext -> AiContextSerializer
       |
       v
  Firebase Anonymous ID Token
       |
       v
  HTTPS POST /recommendation
       |
       v
Cloudflare Worker
  Verify Firebase token -> Validate request -> Check D1 rate limits
       |
       v
  Gemini API (API key stored as Worker Secret)
       |
       v
Flutter
  WorkoutRecommendationMapper -> RecommendationValidator
       |
       v
  Review recommendation -> Start shared workout flow
```

**Data boundary:** workout history, the exercise catalog, the user profile, and progress caches remain in local SQLite. When generating AI recommendations, the app sends the relevant *selected context* (including any available profile and progress values) to the Worker and onward to Gemini. Cloudflare D1 stores AI usage metadata, not the app's workout history.

## Getting Started

### Prerequisites

- **Flutter `3.44.0`**, pinned via `.fvmrc` (recommended: [FVM](https://fvm.app)); the project declares Dart SDK `^3.11.1`.
- A Firebase project configured for this Flutter app, with **Anonymous Authentication enabled**. `main.dart` calls `Firebase.initializeApp()` on startup, so Firebase configuration is needed **even when testing only manual workouts**.
- An Android emulator or a compatible Flutter target; the project's demo flow has been exercised on an Android emulator.
- For **AI recommendations**, a deployed Cloudflare Worker with a server-side Gemini key and D1 binding. Manual workouts, local History, and Progress do not require a successful Gemini request.

### Flutter Application

From the project root:

```bash
# Install the version specified in .fvmrc, if needed
fvm install

# Fetch packages
fvm flutter pub get

# Regenerate Drift / Injectable code when source annotations or tables change
fvm dart run build_runner build --delete-conflicting-outputs

# Launch on your selected device / emulator
fvm flutter run
```

You can also specify a target with `fvm flutter devices` and `fvm flutter run -d <device-id>`.

If FVM is not installed, use the corresponding `flutter` and `dart` commands with a compatible SDK.

Firebase configuration is loaded from the FlutterFire-generated `lib/firebase_options.dart` and relevant platform-specific Firebase setup. When forking the app, configure **your own Firebase project** (for example, using the FlutterFire CLI) and enable Anonymous Authentication. Do not assume the original project's Firebase configuration will work for your deployment.

**Important:** Do **not** pass `GEMINI_API_KEY` into the Flutter app using `--dart-define`. The Flutter application communicates with the Worker; the Gemini key belongs only in the Worker environment.

The Flutter backend endpoint is currently configured in:

```text
lib/features/recommendation/data/datasources/gemini_remote_data_source.dart
```

If you deploy your own Worker, update the endpoint used by this data source to point to your deployment's `/recommendation` route. The app's Firebase project and the Worker's `FIREBASE_PROJECT_ID` must match.

### Cloudflare Worker Configuration

The backend is located in `backend/cloudflare-worker/`. Its source uses these bindings:

| Binding | Type | Purpose |
|---|---|---|
| `GEMINI_API_KEY` | Worker Secret | Server-side Gemini API credential |
| `FIREBASE_PROJECT_ID` | Environment variable | Verify Firebase token audience and issuer |
| `DB` | Cloudflare D1 binding | Store per-user request counters |

The D1 table is defined in `backend/cloudflare-worker/migrations/0001_create_rate_limits.sql`.

The Worker source sets **`DAILY_AI_LIMIT = 12` per Firebase UID per UTC day** and **`AI_COOLDOWN_MS = 60_000` (60 seconds)** between accepted requests. These are application-level limits; Gemini's upstream quota is separate. A request recorded in D1 may still consume a slot if Gemini later fails. **Verify the deployed Worker has the same values**: dashboard deployments and repository commits are not automatically synchronized.

The backend documentation describes **manual Cloudflare Dashboard deployment**, not a repository-to-Cloudflare CI/CD pipeline. See the [backend README](backend/cloudflare-worker/README.md) for API and deployment details.

> **Security:** Never commit actual API keys, tokens, Worker secrets, or private Firebase credentials. Firebase's public application configuration is not a substitute for protecting backend secrets.

## Testing and Code Quality

```bash
# Static analysis
fvm flutter analyze

# All Flutter tests
fvm flutter test

# One specific test file
fvm flutter test test/features/progress/domain/services/recent_progress_analyzer_test.dart
```

The test suite covers domain calculations and use cases, recommendation logic, and parts of the Drift-backed workout lifecycle. Some tests use **in-memory SQLite** through Drift, while isolated dependencies can be mocked with Mocktail.

The project includes generated Drift (`*.g.dart`) and Injectable (`injection.config.dart`) files. Regenerate them after changes to database definitions or injectable constructors, and commit relevant generated files with the source changes.

## Current Scope and Limitations

**Implemented:** AI and manual workout planning; persistent per-set tracking; resume/cancel; completed history; recent and long-term progress analytics; incremental/rebuildable progress caching; Firebase-authenticated Cloudflare Worker integration; and a five-session weight chart.

**Current limitations:**

- Workout records and profile information are **local to the device**; there is no cloud backup or multi-device workout synchronization.
- Firebase Anonymous Authentication provides a per-installation identity for AI access, not a full registration/account management flow or strong abuse prevention by itself.
- The Worker records an accepted request before calling Gemini; failed upstream requests can still consume application-level quota.
- The Worker deployment and D1 setup are currently managed manually, without CI/CD or automated deployment/migration steps.
- The progress chart displays up to five recent weight observations; it does not provide an unlimited historical chart.
- The project is a portfolio application and has not been presented as a production-hardened fitness or security product.

## Screenshots

The app currently includes Home, AI Recommendation, Manual Workout, Workout Tracking, History, Progress, and Profile screens. To display screenshots on GitHub, add image files to a folder such as `docs/screenshots/` and then link them here. No screenshot paths are included yet, to avoid broken images in a fresh clone.

## Possible Next Steps

- Extend widget and integration tests for workout completion, resume, and progress visualization.
- Strengthen concurrent set-update handling and improve recovery from individual save errors.
- Add richer chart interaction or optional volume visualization, keeping the chart grounded in recorded data.
- Automate backend deployment and improve handling of failed Gemini requests and usage accounting.

---

Built as a personal project to practice **Flutter application architecture, reliable local data handling, progress-analysis logic, and secure AI API integration**.
