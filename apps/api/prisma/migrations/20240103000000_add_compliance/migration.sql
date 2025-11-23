-- Add tokenHash to consent_tokens
ALTER TABLE consent_tokens ADD COLUMN IF NOT EXISTS token_hash TEXT;
ALTER TABLE consent_tokens ADD COLUMN IF NOT EXISTS ip_address TEXT;
ALTER TABLE consent_tokens ADD COLUMN IF NOT EXISTS source TEXT;

CREATE INDEX IF NOT EXISTS idx_consent_tokens_token_hash ON consent_tokens(token_hash);

-- Create compliance_policies table
CREATE TABLE IF NOT EXISTS compliance_policies (
  id                TEXT PRIMARY KEY,
  tenant_id         TEXT NOT NULL,
  name              TEXT NOT NULL,
  enforce_dnc       BOOLEAN NOT NULL DEFAULT TRUE,
  enforce_consent   BOOLEAN NOT NULL DEFAULT TRUE,
  allow_override    BOOLEAN NOT NULL DEFAULT FALSE,
  require_admin_approval BOOLEAN NOT NULL DEFAULT TRUE,
  metadata          JSONB,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_compliance_policies_tenant_name ON compliance_policies(tenant_id, name);
CREATE INDEX IF NOT EXISTS idx_compliance_policies_tenant_id ON compliance_policies(tenant_id);

ALTER TABLE compliance_policies
  ADD CONSTRAINT fk_compliance_policies_tenant
  FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE;

-- Create compliance_overrides table
CREATE TABLE IF NOT EXISTS compliance_overrides (
  id                TEXT PRIMARY KEY,
  tenant_id         TEXT NOT NULL,
  call_id           TEXT,
  phone_number      TEXT NOT NULL,
  reason            TEXT NOT NULL,
  policy_id         TEXT,
  user_id           TEXT,
  approved_at       TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at        TIMESTAMPTZ,
  metadata          JSONB,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_compliance_overrides_tenant_id ON compliance_overrides(tenant_id);
CREATE INDEX IF NOT EXISTS idx_compliance_overrides_phone_number ON compliance_overrides(phone_number);
CREATE INDEX IF NOT EXISTS idx_compliance_overrides_call_id ON compliance_overrides(call_id);
CREATE INDEX IF NOT EXISTS idx_compliance_overrides_expires_at ON compliance_overrides(expires_at);

ALTER TABLE compliance_overrides
  ADD CONSTRAINT fk_compliance_overrides_tenant
  FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE;

ALTER TABLE compliance_overrides
  ADD CONSTRAINT fk_compliance_overrides_user
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL;

