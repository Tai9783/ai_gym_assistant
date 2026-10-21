# AI Gym Assistant — Cloudflare Worker Backend

## Overview

This directory contains the serverless backend for **AI Gym Assistant**, a Flutter application designed to help users manage workouts, track exercise performance, and receive AI-powered workout recommendations.

The backend is deployed on **Cloudflare Workers** and integrates **Firebase Authentication**, **Cloudflare D1**, and the **Google Gemini API**.

Its primary purpose is to provide a secure intermediary between the Flutter application and Gemini, ensuring that API credentials remain on the server while enforcing authentication, request validation, and usage limits.

### Key Responsibilities

- Authenticate incoming requests using Firebase ID tokens.
- Verify token signatures and required authentication claims.
- Validate workout recommendation requests before processing.
- Enforce daily AI request limits for individual Firebase users.
- Apply a cooldown period between accepted AI requests.
- Generate personalized workout recommendations using Gemini.
- Return structured JSON responses to the Flutter application.
- Handle authentication, validation, rate limiting, and AI service errors.

## Technology Stack

| Technology | Purpose |
|---|---|
| Cloudflare Workers | Serverless API execution |
| JavaScript | Backend implementation |
| Firebase Authentication | User authentication and identity verification |
| Cloudflare D1 | SQLite-based database for request usage tracking |
| Google Gemini API | AI-powered workout recommendations |
| Web Crypto API | Verification of Firebase JWT signatures |
| Git | Source code version control |

The backend is designed to operate using the free-tier services available for this project, subject to each provider's current usage limits.

---

## Architecture

The Flutter application communicates with the Cloudflare Worker instead of calling Gemini directly.

This prevents the Gemini API key from being embedded in the mobile application.

```text
+-----------------------------+
|      Flutter Application    |
|                             |
|   AI Recommendation Feature |
+--------------+--------------+
               |
               | HTTPS POST /recommendation
               | Firebase ID Token
               | AI Context
               v
+-----------------------------+
|       Cloudflare Worker     |
|                             |
|  1. Verify Firebase Token   |
|  2. Validate Request        |
|  3. Enforce Rate Limits     |
+--------------+--------------+
               |
               v
+-----------------------------+
|        Cloudflare D1        |
|                             |
|  Daily Request Counter      |
|  Cooldown Timestamp         |
+--------------+--------------+
               |
               | Request allowed
               v
+-----------------------------+
|       Google Gemini API     |
|                             |
|  Analyze Workout Context    |
|  Generate Recommendation    |
+--------------+--------------+
               |
               | Structured JSON
               v
+-----------------------------+
|       Cloudflare Worker     |
|                             |
|  Process Gemini Response    |
+--------------+--------------+
               |
               | HTTP Response
               v
+-----------------------------+
|      Flutter Application    |
|                             |
|  Display AI Recommendation  |
+-----------------------------+
```

### Request Processing Flow

1. The Flutter application authenticates the user through Firebase Authentication.
2. The application obtains a Firebase ID token.
3. Flutter sends the token and workout context to the Cloudflare Worker.
4. The Worker verifies the token using Google's public signing keys.
5. The Worker validates the request payload.
6. Cloudflare D1 checks the user's daily request count and cooldown.
7. If the request is permitted, the Worker forwards the workout context to Gemini.
8. Gemini generates a structured workout recommendation.
9. The Worker returns the recommendation to Flutter.
10. The Flutter application displays the generated workout.

Requests that fail authentication, validation, or rate limiting are rejected before reaching Gemini.

---

## Project Structure

```text
backend/
└── cloudflare-worker/
    ├── src/
    │   └── index.js
    │
    ├── migrations/
    │   └── 0001_create_rate_limits.sql
    │
    └── README.md
```

### File Descriptions

| File | Description |
|---|---|
| `src/index.js` | Main Worker implementation, including authentication, request validation, rate limiting, and Gemini integration |
| `migrations/0001_create_rate_limits.sql` | SQL definition for the D1 request-tracking table |
| `README.md` | Backend architecture, configuration, API documentation, and operational notes |

The Worker currently uses a single JavaScript entry point to keep the implementation straightforward.

The code can be separated into authentication, validation, rate limiting, and Gemini modules as the backend grows.

---

## Authentication

### Firebase Anonymous Authentication

The Flutter application currently uses **Firebase Anonymous Authentication** to obtain a unique Firebase user identity without requiring registration.

Each anonymous user is assigned a Firebase UID.

The UID is used by the backend to track AI request usage.

### Firebase ID Token Verification

Flutter attaches its Firebase ID token to each recommendation request:

```http
Authorization: Bearer <FIREBASE_ID_TOKEN>
```

The Worker verifies the token before accepting the request.

The verification process includes:

- Checking the token's JWT structure.
- Validating the RS256 signing algorithm.
- Fetching Google's Firebase public signing keys.
- Verifying the JWT signature with the Web Crypto API.
- Validating the token issuer.
- Validating the Firebase project audience.
- Checking token expiration and issuance timestamps.
- Extracting the authenticated Firebase UID.

The Worker uses Google's public JWK endpoint for signature verification.

Public keys are cached according to their cache-control information, subject to the implementation's maximum cache duration.

**Security principle:** The Firebase UID used for rate limiting is obtained from a verified token, not from an untrusted UID supplied by the client.

---

## API Documentation

### Generate Workout Recommendation

**Endpoint**

```http
POST /recommendation
```

**Headers**

```http
Authorization: Bearer <FIREBASE_ID_TOKEN>
Content-Type: application/json
```

### Request Body

The request contains an `aiContext` object with information about the requested workout, user profile, exercise catalog, and available performance history.

Example:

```json
{
  "aiContext": {
    "request": {
      "focus": "upper_body",
      "exerciseIds": ["exercise_001"],
      "note": "Focus on controlled repetitions."
    },
    "profile": {
      "goal": "muscle_gain",
      "weightKg": 70,
      "heightCm": 175,
      "age": 25
    },
    "exercises": [
      {
        "exercise": {
          "id": "exercise_001",
          "name": "Lat Pulldown",
          "muscleGroup": "Back"
        },
        "recent": null,
        "longTerm": null
      }
    ]
  }
}
```

The example illustrates the API structure. Exercise IDs and profile values are supplied by the application.

### Request Fields

| Field | Description |
|---|---|
| `aiContext.request.focus` | Requested workout focus |
| `aiContext.request.exerciseIds` | Exercise IDs selected by the user |
| `aiContext.request.note` | Optional workout instructions or preferences |
| `aiContext.profile` | Optional user fitness information |
| `aiContext.exercises` | Available exercises with associated progress data |
| `exercise.id` | Unique exercise identifier |
| `exercise.name` | Exercise display name |
| `exercise.muscleGroup` | Target muscle group |
| `recent` | Optional recent workout performance |
| `longTerm` | Optional longer-term progress information |

The Worker validates the overall request structure and checks that selected exercise IDs belong to the provided exercise list.

Duplicate selected exercise IDs and duplicate exercise catalog IDs are rejected.

### Successful Response

**HTTP 200 OK**

Example:

```json
{
  "exercises": [
    {
      "exerciseId": "exercise_001",
      "sets": [
        {
          "suggestedWeight": 35,
          "suggestedReps": 12
        },
        {
          "suggestedWeight": 35,
          "suggestedReps": 12
        },
        {
          "suggestedWeight": 35,
          "suggestedReps": 10
        }
      ]
    }
  ]
}
```

Each recommended exercise includes:

- `exerciseId`: The exercise identifier.
- `sets`: A list of suggested workout sets.
- `suggestedWeight`: Suggested weight in kilograms.
- `suggestedReps`: Suggested repetition count.

Suggested weights must be non-negative, and suggested repetition counts must be positive.

The recommendation prompt instructs Gemini to use only exercises provided in the request and to apply conservative progression when appropriate.

---

## Rate Limiting

Rate limiting protects the Gemini integration from excessive or repeated requests.

The implementation uses Cloudflare D1 to track usage for each verified Firebase UID.

### Current Rate Limit Rules

| Rule | Value |
|---|---|
| Daily AI request limit | 10 accepted requests per UID |
| Cooldown period | 60 seconds |
| Daily tracking timezone | UTC |
| Database | Cloudflare D1 |
| User identifier | Verified Firebase UID |

The daily request limit and cooldown can be configured in the Worker source code.

The current backend is configured for a maximum of **10 requests per Firebase UID per UTC day**.

### Daily Limit

The daily request counter is stored using a composite key consisting of:

```text
(uid, day)
```

The Worker determines the current UTC date and checks the user's existing request count.

When the daily limit is reached, the Worker rejects additional requests with HTTP `429`.

### Cooldown

A minimum 60-second interval is enforced between accepted requests from the same UID.

If another request arrives before the cooldown expires, the Worker returns HTTP `429` with the remaining waiting period.

### Atomic Database Update

The Worker uses a SQLite `INSERT ... ON CONFLICT DO UPDATE` statement with conditional updates.

This allows the request count and last-request timestamp to be updated together, reducing the risk of concurrent requests bypassing the configured limits.

### Daily Reset

Daily usage is tracked by UTC calendar date.

For users in Vietnam (UTC+7), a new UTC day begins at **07:00 local time**.

The previous day's database records are not required to be deleted for the next day's counter to begin.

---

## Database Schema

Cloudflare D1 stores AI usage information in the `ai_rate_limits` table.

The schema is defined in:

```text
migrations/0001_create_rate_limits.sql
```

```sql
CREATE TABLE IF NOT EXISTS ai_rate_limits (
    uid TEXT NOT NULL,
    day TEXT NOT NULL,
    request_count INTEGER NOT NULL DEFAULT 0,
    last_request_at INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (uid, day)
);
```

### Column Descriptions

| Column | Type | Description |
|---|---|---|
| `uid` | TEXT | Verified Firebase user identifier |
| `day` | TEXT | UTC date formatted as `YYYY-MM-DD` |
| `request_count` | INTEGER | Number of accepted requests for the user on that date |
| `last_request_at` | INTEGER | Timestamp of the latest accepted request, in Unix milliseconds |

The combination of `uid` and `day` is the primary key.

**Migration note:** The SQL file documents the schema currently used by the deployed application. Database migration execution has not yet been automated through Wrangler.

---

## Error Handling

The backend returns appropriate HTTP status codes for authentication, validation, rate limiting, and upstream service failures.

### HTTP Status Codes

| HTTP Status | Meaning |
|---|---|
| `200` | Workout recommendation generated successfully |
| `400` | Invalid request body or AI context |
| `401` | Missing, invalid, or unverifiable Firebase authentication |
| `404` | Endpoint not found |
| `405` | HTTP method not allowed |
| `413` | Request payload exceeds the permitted size |
| `429` | Application-level AI request limit or cooldown reached |
| `500` | Missing required server configuration |
| `502` | Recommendation generation failed at the Gemini integration |
| `503` | Authentication key retrieval or rate limiting infrastructure is unavailable |

### Daily Limit Response

**HTTP 429 Too Many Requests**

```json
{
  "error": "daily_limit_reached",
  "message": "Daily AI request limit reached.",
  "resetAt": "2026-10-22T00:00:00.000Z"
}
```

The `resetAt` field indicates when the next UTC day begins.

The Flutter application converts this timestamp to the user's local timezone when displaying the message.

### Cooldown Response

**HTTP 429 Too Many Requests**

```json
{
  "error": "cooldown_active",
  "message": "Please wait before trying again.",
  "retryAfterSeconds": 45
}
```

The number of remaining seconds depends on the user's last accepted request.

The Worker also supplies a `Retry-After` response header.

### Recommendation Service Failure

**HTTP 502 Bad Gateway**

```json
{
  "error": "recommendation_unavailable",
  "message": "Unable to generate workout recommendation."
}
```

This response is returned when recommendation generation fails within the Gemini integration.

**Important:** A `502` from the Worker does not necessarily indicate that Cloudflare itself is unavailable. For example, Gemini may return an upstream `429` because its own API quota has been exceeded, which the current Worker can surface as `502`.

---

## Gemini API Integration

The Worker communicates with Google's Gemini API to generate personalized workout recommendations.

The model identifier is configured in `src/index.js`.

The recommendation request contains:

- System instructions defining recommendation rules.
- The serialized AI context from Flutter.
- Structured JSON response configuration.
- A response schema describing exercises and suggested sets.

### Recommendation Constraints

The system instructions require Gemini to:

1. Use exercises from the provided exercise catalog.
2. Preserve all explicitly selected exercise IDs without introducing additional exercises.
3. Select appropriate exercises when none are explicitly selected.
4. Recommend sets, repetitions, and weights.
5. Consider recent and long-term workout performance.
6. Apply conservative progression when the user has struggled with previous targets.
7. Consider gradual progression when previous targets have been achieved consistently.
8. Avoid inventing historical workout data.
9. Return structured JSON instead of natural-language explanations.

### API Credential Security

The Gemini API key is stored in a Cloudflare Worker Secret.

The Worker accesses it through:

```javascript
env.GEMINI_API_KEY
```

The actual API key must never be included in the Flutter source code, committed to Git, or written to application logs.

### Gemini Quotas

Gemini API quotas are managed independently of the application's D1 rate limits.

The Worker enforces its own per-user limits, but Google may also enforce project-level request and token limits.

Increasing the application's daily request limit does not increase the quota available from Google.

---

## Environment Configuration

The deployed Worker requires the following environment bindings:

| Binding | Type | Description |
|---|---|---|
| `FIREBASE_PROJECT_ID` | Environment variable | Firebase project identifier used for token validation |
| `GEMINI_API_KEY` | Secret | Google Gemini API credential |
| `DB` | D1 database binding | Database used to track AI request usage |

### Configuration Guidelines

- Configure the Firebase project identifier in the Cloudflare Worker settings.
- Store the Gemini API key as a Secret.
- Bind the Cloudflare D1 database using the exact binding name `DB`.
- Confirm that the D1 database contains the `ai_rate_limits` table.
- Ensure that the Flutter application uses the corresponding Firebase project.
- Do not expose secret values through API responses or logging.

**Security:** Never commit real API keys, service account credentials, access tokens, `.env` files containing secrets, or `.dev.vars` files containing secrets.

---

## Deployment

### Current Deployment Method

The backend is currently deployed manually through the Cloudflare Dashboard.

To update the Worker:

1. Open the Cloudflare Dashboard.
2. Navigate to **Workers & Pages**.
3. Select the `ai-gym-assistant-api` Worker.
4. Open **Edit code**.
5. Apply the reviewed JavaScript changes.
6. Confirm the required environment bindings are configured.
7. Deploy the updated Worker.
8. Check the active deployment and available logs.

The deployed Worker exposes the `/recommendation` endpoint through its Cloudflare Workers domain.

### Source Code and Deployment Synchronization

The repository contains a version-controlled copy of the backend source.

**Committing changes to Git does not automatically deploy them to Cloudflare.**

Likewise, editing code directly in the Cloudflare Dashboard does not automatically update the Git repository.

Until an automated deployment workflow is introduced, developers must manually keep the deployed Worker and the repository source synchronized.

The repository should contain the reviewed source code corresponding to the intended deployment version.

### Database Migrations

The initial D1 table was created through Cloudflare's database tooling.

The migration SQL is retained in this repository for documentation and future reproducibility.

It should not be reapplied unnecessarily to the existing production database.

Automated migration management is a potential future improvement.

---

## Security Considerations

The backend implements several defensive measures:

### Authentication

Requests must include a valid Firebase ID token.

Firebase user identity is determined by verified JWT claims.

### Server-Side API Key Storage

The Gemini API key is kept on the Worker rather than distributed with the Flutter application.

### Input Validation

The Worker checks the structure and size of incoming AI context data.

It also verifies that requested exercise IDs belong to the supplied catalog.

### Request Size Restrictions

The Worker restricts request body and serialized AI context sizes to limit excessively large payloads.

### Rate Limiting

Daily request limits and cooldowns reduce repeated or excessive AI requests.

### Safe Logging

The Worker logs relevant operational errors without intentionally logging API keys, Firebase ID tokens, or full AI context payloads.

### Current Security Limitations

Firebase Anonymous Authentication does not provide a permanent, abuse-resistant identity.

A user may potentially create another anonymous Firebase account and receive a different UID.

Therefore, UID-based rate limiting is a basic abuse-prevention measure, not a comprehensive anti-abuse solution.

Additional protection may be necessary for a public production service operating at scale.

---

## Current Limitations

The current backend provides the core functionality required for the AI recommendation feature.

However, several areas can be improved.

### 1. Failed Gemini Requests Can Consume Application Quota

The D1 request counter is currently updated before the Worker calls Gemini.

Consequently, a request accepted by D1 may consume one application-level request even if Gemini subsequently fails.

A future improvement should address failure handling while preserving safe behavior under concurrent requests.

### 2. Upstream Gemini Quota Errors

Google Gemini may return HTTP `429` because of its own usage limits.

The current Worker can convert these failures into a generic HTTP `502` response.

Future handling should distinguish upstream Gemini quota exhaustion from application-level rate limiting.

### 3. Anonymous User Abuse Prevention

Rate limiting currently relies on verified Firebase UIDs.

Additional protections may be considered if the application becomes publicly available to a larger user base.

### 4. Manual Deployment

Worker deployment and source synchronization are currently performed manually.

Future improvements may introduce:

- Wrangler-based deployment.
- Version-controlled Cloudflare configuration.
- Automated database migrations.
- CI/CD workflows.
- Automated backend tests.
- More detailed structured error responses.
- Improved request usage accounting.

These are potential improvements and are not part of the current deployed implementation.

---

## Relationship to the Flutter Application

The backend supports the Flutter application's **AI Recommendation** feature.

The Flutter application is responsible for:

- Managing the user interface.
- Authenticating users through Firebase.
- Collecting workout preferences.
- Preparing exercise and progress context.
- Sending authenticated recommendation requests.
- Parsing the returned recommendation.
- Displaying loading, success, and failure states.
- Presenting rate limit and cooldown messages.
- Allowing users to return to a previously generated recommendation.

The Worker is responsible for backend authentication checks, request validation, usage enforcement, and Gemini communication.

This separation keeps the AI integration and its credentials outside the mobile client while allowing Flutter to focus on application logic and user experience.

---

## Summary

The Cloudflare Worker backend provides a lightweight, serverless integration layer between AI Gym Assistant and Google Gemini.

By combining Firebase Authentication, Cloudflare D1, request validation, and per-user rate limiting, the project demonstrates practical backend concerns such as API protection, identity verification, service integration, and error handling.

The implementation is intentionally small and focused on the needs of the Flutter application, while leaving room for improved deployment automation, monitoring, and abuse prevention as the project evolves.

---

**Project:** AI Gym Assistant  
**Component:** Cloudflare Worker Backend  
**Primary Language:** JavaScript  
**Deployment Platform:** Cloudflare Workers  
**Database:** Cloudflare D1  
**Authentication:** Firebase Authentication  
**AI Provider:** Google Gemini
