-- Create transcripts table
CREATE TABLE IF NOT EXISTS transcripts (
  id           TEXT PRIMARY KEY,
  tenant_id    TEXT NOT NULL,
  call_id      TEXT NOT NULL UNIQUE,
  engine       TEXT NOT NULL,
  language     TEXT,
  duration_sec INT,
  full_text    TEXT NOT NULL,
  speaker_labels BOOLEAN DEFAULT FALSE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create transcript_segments table
CREATE TABLE IF NOT EXISTS transcript_segments (
  id             TEXT PRIMARY KEY,
  transcript_id  TEXT NOT NULL REFERENCES transcripts(id) ON DELETE CASCADE,
  idx            INT NOT NULL,
  start_sec      NUMERIC(10,3) NOT NULL,
  end_sec        NUMERIC(10,3) NOT NULL,
  speaker        TEXT,
  text           TEXT NOT NULL
);

-- Create transcript_analysis table
CREATE TABLE IF NOT EXISTS transcript_analysis (
  transcript_id TEXT PRIMARY KEY REFERENCES transcripts(id) ON DELETE CASCADE,
  billable      BOOLEAN,
  application_submitted BOOLEAN,
  reasoning     TEXT
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_transcripts_tenant_id ON transcripts(tenant_id);
CREATE INDEX IF NOT EXISTS idx_transcripts_call_id ON transcripts(call_id);
CREATE INDEX IF NOT EXISTS idx_transcripts_created_at ON transcripts(created_at);
CREATE INDEX IF NOT EXISTS idx_transcript_segments_transcript_id ON transcript_segments(transcript_id);
CREATE INDEX IF NOT EXISTS idx_transcript_segments_idx ON transcript_segments(transcript_id, idx);

-- Enable pg_trgm extension for fuzzy text search
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Create trigram index for full-text search
CREATE INDEX IF NOT EXISTS idx_transcripts_full_text_trgm
  ON transcripts USING GIN (full_text gin_trgm_ops);

