# AI Gym Assistant

A Flutter application that helps users plan, track, and progressively improve their gym workouts. It combines a local-first SQLite data store with AI-generated workout recommendations (via the Gemini API) and a deterministic progress-analysis engine that turns raw workout history into actionable trends.

> This is a learning / mini-project. The codebase favors clarity and correctness over production-grade hardening (see [Current Implementation Status](#current-implementation-status)).

## Key Features

### AI-Powered Workout Recommendations
- The user picks a muscle group focus (chest, back, legs, shoulders, arms, or full body), optionally selects specific exercises from the catalog, and may add a free-text note.
- The app assembles an **AI Context** from the request, the exercise catalog, the user's profile, and that user's **Recent** and **Long-Term** progress for each candidate exercise.
- The context is sent to the Gemini API with a structured JSON response schema. The model returns a workout plan (exercises, sets, suggested weight/reps).
- The response is validated against the original context (every returned exercise must come from the allowed catalog list, no duplicates, positive reps, non-negative weight, and — when specific exercises were requested — the response must match them exactly) before it is ever shown to the user or turned into a workout.

### Manual Workout Creation
- As an alternative to the AI flow, the user can select exercises and manually set the target number of sets, weight, and reps for each one.
- Manual targets are converted into the same `WorkoutExercise` / `ExerciseSet` structure produced by the AI flow, so both paths share the exact same downstream execution, tracking, and history logic.

### Workout Tracking (Suggested vs. Actual)
- Each set tracks a **suggested** weight/reps (from AI or manual input) separately from the **actual** weight/reps the user performs.
- Sets start as `pending` and must be explicitly marked `completed` (with real actual values) by the user — pre-filled suggested values are never silently treated as a completed set.
- A workout session can be finished at any time; a confirmation dialog warns the user if sets are still incomplete.

### Workout History & Progress Analysis
- Completed sessions are persisted to SQLite and browsable in the History tab, showing suggested vs. actual values per set.
- A deterministic (non-AI) analysis pipeline summarizes each exercise occurrence, then computes:
  - **Recent progress** — based on the last 5 sessions for a given exercise (hit/miss streaks, target-hit set rate, latest weight/reps, short-term weight & volume trend).
  - **Long-term progress** — based on the exercise's entire completed history (lifetime session count, best weight ever achieved, overall hit/miss counts, long-term weight & volume trend).
- This same analysis feeds both the Progress tab UI and the AI Context used for recommendations, so the AI reasons over pre-computed statistics rather than raw historical data.

### Exercise Catalog
- A local SQLite-backed catalog of exercises (seeded on first launch with 10 sample exercises across chest, back, legs, shoulders, and arms).
- Used for exercise selection, muscle-group filtering, and resolving exercise IDs to display names throughout the app.

### User Profile
- Stores a fitness goal (`muscleGain`, `fatLoss`, or `strength`) plus optional weight, height, and age.
- Included in the AI Context so recommendations can be tailored to the user's stated goal.

## Technology Stack

| Concern | Choice |
|---|---|
| Framework | Flutter (SDK `^3.11.1`), managed via [FVM](https://fvm.app) (pinned to Flutter `3.44.0`) |
| State management | [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) |
| Local persistence | [`drift`](https://pub.dev/packages/drift) (SQLite) + [`drift_flutter`](https://pub.dev/packages/drift_flutter) |
| Dependency injection | [`get_it`](https://pub.dev/packages/get_it) + [`injectable`](https://pub.dev/packages/injectable) (code-generated) |
| Routing | [`go_router`](https://pub.dev/packages/go_router) with a `StatefulShellRoute` for bottom-tab navigation |
| AI recommendations | Google **Gemini** API (`gemini-3.8-flash`), called directly over HTTP via the [`http`](https://pub.dev/packages/http) package |
| IDs | [`uuid`](https://pub.dev/packages/uuid) |
| Testing | `flutter_test` + [`mocktail`](https://pub.dev/packages/mocktail) (for the Gemini/HTTP boundary) |

## Architecture

The project follows a **feature-first, Clean Architecture-inspired** structure. Each feature under `lib/features/<feature>/` is split into three layers:

- **`domain/`** — framework-agnostic business logic: entities, repository *interfaces*, use cases, and pure calculation services. Nothing here imports Flutter, Drift, or `http`.
- **`data/`** — implements the domain repository interfaces using Drift (`datasources/`), maps between Drift rows/companions and domain entities (`mappers/`), and (for `recommendation`) calls the Gemini HTTP API and validates its output.
- **`presentation/`** — BLoCs (`flutter_bloc`) that orchestrate use cases and expose UI state, plus the pages/widgets that render it.

Cross-feature dependencies flow through domain repository **interfaces**, injected via constructor injection — a feature never reaches into another feature's Drift tables directly. For example, the `progress` feature depends on `WorkoutRepository` (owned by the `workout` feature) to read raw history, but has no knowledge of its SQLite schema.

### Dependency Injection

`get_it` + `injectable` wire the whole dependency graph. Classes are annotated with `@injectable` (new instance per resolution) or `@LazySingleton()` / `@LazySingleton(as: SomeInterface)` (singleton, optionally bound to an abstract type). Running the build step (see [Testing and Code Quality](#testing-and-code-quality)) regenerates `lib/core/di/injection.config.dart`, which is committed to the repository. `lib/core/di/injection.dart` exposes the global `getIt` instance used by pages and the router to resolve BLoCs and use cases.

### Local Persistence

A single Drift `AppDatabase` (`lib/core/database/app_database.dart`) defines all tables:

- `WorkoutSessions`, `WorkoutExercises`, `ExerciseSets` — raw workout history (the source of truth).
- `ExerciseDefinitions` — the exercise catalog.
- `UserProfiles` — the single-row user profile.

Schema changes are handled through `schemaVersion` and `MigrationStrategy.onUpgrade`. Tests use `AppDatabase.forTesting(NativeDatabase.memory())` for isolated in-memory databases.

### Progress Analysis Pipeline

```
WorkoutRepository (Drift)
        │  raw WorkoutSession / WorkoutExercise / ExerciseSet
        ▼
ExerciseSessionSummarizer        — one exercise occurrence → ExerciseSessionSummary
        │
        ▼
GetExerciseProgress (use case)   — orchestrates the summarizer + analyzers below
        │
        ├──► RecentProgressAnalyzer    → RecentExerciseProgress   (last 5 sessions)
        └──► LongTermProgressAnalyzer  → LongTermExerciseProgress (entire history)
```

`SessionTargetClassifier` (hit / miss / unknown) and `LongTermTrendCalculator` are shared, pure domain services injected into both analyzers so hit/miss and trend semantics stay consistent between Recent and Long-Term results. `GetExerciseProgress` is reused by both the Progress tab (`ProgressBloc`) and the recommendation flow (`PrepareAiContext`), so the UI and the AI always see the same numbers.

### AI Recommendation Pipeline

```
WorkoutRequest (focus, exerciseIds, note)
        │
        ▼
PrepareAiContext        — resolves exercises from the catalog, fetches Recent/LongTerm
        │                  progress per exercise, loads the user profile
        ▼
AiContextBuilder        — assembles the AiContext value object
        │
        ▼
AiContextSerializer     — AiContext → JSON (allowlisted fields only)
        │
        ▼
GeminiRemoteDataSource  — POSTs to the Gemini API with a structured output schema
        │
        ▼
WorkoutRecommendationMapper  — JSON → WorkoutRecommendation
        │
        ▼
RecommendationValidator — rejects disallowed/duplicate/invalid exercises or sets
        │
        ▼
WorkoutRecommendation
```

### How AI and Manual Workouts Converge

Both entry points on the Home page build a `WorkoutRequest` and ultimately produce a `List<WorkoutExercise>`:

- **AI path**: `RecommendationBloc` → `GenerateRecommendation` → `WorkoutRecommendation`, converted to `List<WorkoutExercise>` by `RecommendationWorkoutMapper`.
- **Manual path**: `ManualWorkoutPage` collects per-set targets into `ManualExerciseTarget`, converted to `List<WorkoutExercise>` by `ManualWorkoutMapper`.

From that point on, both paths pass the same `List<WorkoutExercise>` into the shared `WorkoutPage`/`WorkoutBloc`, which calls `StartWorkout`, `UpdateExerciseSet`, and `FinishWorkout` against the same `WorkoutRepository` — there is only one execution and persistence path for a workout, regardless of how it was planned.

## Project Structure

```
lib/
├── app/
│   ├── pages/                 # HomePage, MainShellPage (bottom-tab shell)
│   └── router/                # go_router configuration (app_router.dart)
├── core/
│   ├── database/              # AppDatabase (Drift) + table definitions
│   └── di/                    # GetIt/Injectable setup (injection.dart, injection.config.dart)
└── features/
    ├── exercise_catalog/      # Exercise list, seeding, muscle-group filtering
    │   ├── domain/            # ExerciseDefinition, ExerciseRepository, GetExercises
    │   ├── data/               # Drift data source, repository impl, mapper
    │   └── presentation/       # ExerciseCatalogBloc, SelectExercisePage
    ├── workout/                # Workout session lifecycle (start/update/finish)
    │   ├── domain/             # WorkoutSession/Exercise/Set, WorkoutRepository, use cases
    │   ├── data/                # Drift data source, repository impl, mappers
    │   └── presentation/        # WorkoutBloc, WorkoutPage, ManualWorkoutPage, mappers/models
    ├── history/                 # Browsing completed workout sessions
    │   └── presentation/         # HistoryBloc, HistoryPage
    ├── progress/                 # Deterministic progress analysis
    │   ├── domain/
    │   │   ├── entities/          # ExerciseSessionSummary, RecentExerciseProgress,
    │   │   │                      # LongTermExerciseProgress, ProgressTrend
    │   │   ├── services/          # ExerciseSessionSummarizer, SessionTargetClassifier,
    │   │   │                      # RecentProgressAnalyzer, LongTermProgressAnalyzer,
    │   │   │                      # LongTermTrendCalculator
    │   │   └── usecases/          # GetExerciseProgress (orchestrator)
    │   └── presentation/           # ProgressBloc, ProgressPage
    ├── profile/                   # User profile (goal, weight, height, age)
    │   ├── domain/ / data/ / presentation/
    └── recommendation/             # AI Context + Gemini integration
        ├── domain/
        │   ├── entities/           # WorkoutRequest, AiContext, WorkoutRecommendation
        │   ├── services/           # AiContextBuilder, RecommendationValidator
        │   └── usecases/           # PrepareAiContext, GenerateRecommendation
        ├── data/
        │   ├── datasources/         # GeminiRemoteDataSource
        │   ├── prompts/              # RecommendationPrompt (system instruction)
        │   ├── schemas/               # WorkoutRecommendationSchema (Gemini response schema)
        │   ├── serializers/            # AiContextSerializer (AiContext → JSON)
        │   ├── mappers/                 # WorkoutRecommendationMapper (JSON → domain)
        │   └── repositories/             # RecommendationRepositoryImpl
        └── presentation/                  # RecommendationBloc, RecommendationPage, mapper
```

## How the Application Works

1. **Home** — the user picks a muscle group and/or specific exercises and writes an optional note, then chooses **AI đề xuất** (AI recommendation) or **Tự tạo buổi tập** (manual workout).
2. **Planning**:
   - *AI path* → `/recommendation`: `RecommendationBloc` prepares the AI context, calls Gemini, validates the result, and shows a plan the user can regenerate or accept.
   - *Manual path* → `/manual-workout`: the user enters sets/weight/reps per selected exercise directly.
3. **Execution** → `/workout`: `WorkoutBloc` starts a session from the chosen exercises. The user records actual weight/reps per set and marks sets completed; the session can be finished once ready.
4. **Persistence**: `WorkoutRepositoryImpl` upserts the session, its exercises, and its sets into SQLite via Drift.
5. **History** — completed sessions are listed with their full suggested-vs-actual breakdown per set.
6. **Progress** — for any exercise with history, `GetExerciseProgress` recomputes Recent and Long-Term progress straight from SQLite on demand (no separate cached/denormalized progress table).
7. **Future recommendations** reuse the same progress pipeline as an input, closing the loop between past performance and future suggestions.

## Getting Started

### Prerequisites

- [FVM](https://fvm.app) (recommended) with Flutter **3.44.0** as pinned in `.fvmrc`, or a compatible Flutter/Dart SDK directly (`dart --version` must be `>=3.12.0` to satisfy `injectable_generator`).
- A Gemini API key if you want to use the AI recommendation flow (optional — manual workouts, history, and progress work without it).

### Install dependencies

```bash
fvm flutter pub get
# or, without FVM:
flutter pub get
```

### Generate code

Drift tables and Injectable registrations are code-generated. Run this after `pub get` and whenever you change a Drift table, or add/change an `@injectable`/`@LazySingleton` class:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

Generated files (`*.g.dart`, `lib/core/di/injection.config.dart`) are committed to the repository — regenerate and commit them together with the source change that required them.

## Environment Configuration

The AI recommendation feature reads its Gemini API key from a compile-time environment variable, `GEMINI_API_KEY` (see `lib/features/recommendation/data/datasources/gemini_remote_data_source.dart`). It is **not** read from any committed file. If the key is missing, `GeminiRemoteDataSource` throws before making a network call, and `RecommendationBloc` surfaces this as a generation failure — every other feature (manual workouts, tracking, history, progress, profile) works without it.

Supply the key via `--dart-define` when running or building:

```bash
fvm flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
```

The repository's `.gitignore` also excludes a local `gemini.local.json` file, which you may use to keep your own key notes out of version control; it is not read by the application code itself — the key must still be passed through `--dart-define` (or your own run configuration that does so) for the app to pick it up.

## Running the Application

```bash
fvm flutter run --dart-define=GEMINI_API_KEY=your_api_key_here
```

The app registers Android, iOS, Linux, macOS, Windows, and web targets; use `flutter run -d <device>` (or your IDE's device selector) to pick a specific one. Without the Gemini key, use **Tự tạo buổi tập** (manual workout) from the Home screen to exercise the rest of the app.

## Testing and Code Quality

```bash
fvm flutter test                 # run the full test suite
fvm flutter test <path/to/file>  # run a single test file
fvm flutter analyze              # static analysis (flutter_lints)
```

Tests mirror the `lib/` path under `test/`. Domain services and use cases that only depend on other domain logic (progress analyzers, the session summarizer, the trend calculator) are tested by constructing their real collaborators directly — no mocking framework. Code that crosses a real I/O boundary is tested differently:

- **Drift-backed repositories/use cases** (`workout`) are tested against an in-memory Drift database (`AppDatabase.forTesting(NativeDatabase.memory())`), not mocks.
- **The Gemini HTTP boundary** (`recommendation`) is tested with `mocktail`, since it is the one dependency that cannot run in a test environment.

## Current Implementation Status

**Implemented and working end-to-end:**
- Exercise catalog, selection, and muscle-group filtering.
- Manual and AI-assisted workout planning, converging into a single execution flow.
- Workout tracking (suggested vs. actual) and persistence to SQLite.
- Workout history browsing.
- Recent/Long-Term progress analysis computed from real SQLite data, shown in the Progress tab and reused as AI input.
- Gemini-based recommendation generation with response-schema enforcement and post-generation validation.
- User profile storage, used in the AI context.

**Known gaps and simplifications (by design or not yet addressed):**
- `FinishWorkout` does not currently validate that completed sets have actual weight/reps, or force resolution of sets still left `pending` — a session can be marked completed as-is. Progress analysis trends assume reasonably clean actual data as a result.
- There is no persistent cache/table for Recent/Long-Term progress; both are recomputed from raw history on every request. This is simple and correct, but not optimized for very large histories.
- There is no "memory" mechanism for remembering longer-lived user notes (e.g., a recurring injury) across sessions — the per-request `note` field is only used as context for a single recommendation.
- No authentication, backend, or cloud sync — the app is entirely local-first, single-user.
- No automated UI/widget test coverage beyond the default Flutter counter smoke test in `test/widget_test.dart` (which is unrelated to this app's actual UI and currently fails, since the app has no counter).

## Future Improvements

The following are natural next steps given the current architecture, not committed roadmap items:

- Validate workout completeness in `FinishWorkout` before allowing a session to be marked completed.
- Persist a denormalized progress snapshot if/when recomputing from raw history becomes a measurable performance concern.
- Introduce a longer-lived "memory" concept for durable user notes that should influence future recommendations beyond a single request.
- Expand automated test coverage to BLoCs and widgets beyond the current domain/use-case/repository layer.
