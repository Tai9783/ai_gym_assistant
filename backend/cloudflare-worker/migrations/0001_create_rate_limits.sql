
CREATE TABLE IF NOT EXISTS ai_rate_limits (
    uid TEXT NOT NULL,
    day TEXT NOT NULL,
    request_count INTEGER NOT NULL DEFAULT 0,
    last_request_at INTEGER NOT NULL DEFAULT 0,
    PRIMARY KEY (uid, day)
);
