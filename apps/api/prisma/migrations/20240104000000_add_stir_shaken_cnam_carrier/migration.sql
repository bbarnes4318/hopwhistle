-- Add fields to stir_shaken_status
ALTER TABLE stir_shaken_status ADD COLUMN IF NOT EXISTS tenant_id TEXT;
ALTER TABLE stir_shaken_status ADD COLUMN IF NOT EXISTS phone_number TEXT;
ALTER TABLE stir_shaken_status ADD COLUMN IF NOT EXISTS passthru TEXT;
ALTER TABLE stir_shaken_status ADD COLUMN IF NOT EXISTS verified_at TIMESTAMPTZ;
ALTER TABLE stir_shaken_status ADD COLUMN IF NOT EXISTS verified_by TEXT;
ALTER TABLE stir_shaken_status ADD COLUMN IF NOT EXISTS override BOOLEAN DEFAULT FALSE;
ALTER TABLE stir_shaken_status ADD COLUMN IF NOT EXISTS override_reason TEXT;
ALTER TABLE stir_shaken_status ADD COLUMN IF NOT EXISTS override_user_id TEXT;
ALTER TABLE stir_shaken_status ADD COLUMN IF NOT EXISTS metadata JSONB;

CREATE INDEX IF NOT EXISTS idx_stir_shaken_status_tenant_id ON stir_shaken_status(tenant_id);
CREATE INDEX IF NOT EXISTS idx_stir_shaken_status_phone_number ON stir_shaken_status(phone_number);

ALTER TABLE stir_shaken_status
  ADD CONSTRAINT fk_stir_shaken_status_tenant
  FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE;

ALTER TABLE stir_shaken_status
  ADD CONSTRAINT fk_stir_shaken_status_override_user
  FOREIGN KEY (override_user_id) REFERENCES users(id) ON DELETE SET NULL;

-- Create cnam_lookups table
CREATE TABLE IF NOT EXISTS cnam_lookups (
  id            TEXT PRIMARY KEY,
  tenant_id     TEXT NOT NULL,
  phone_number   TEXT NOT NULL,
  caller_name    TEXT,
  provider       TEXT NOT NULL,
  cached         BOOLEAN NOT NULL DEFAULT FALSE,
  cached_until   TIMESTAMPTZ,
  metadata       JSONB,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_cnam_lookups_tenant_phone ON cnam_lookups(tenant_id, phone_number);
CREATE INDEX IF NOT EXISTS idx_cnam_lookups_tenant_id ON cnam_lookups(tenant_id);
CREATE INDEX IF NOT EXISTS idx_cnam_lookups_phone_number ON cnam_lookups(phone_number);

ALTER TABLE cnam_lookups
  ADD CONSTRAINT fk_cnam_lookups_tenant
  FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE;

-- Create carrier_lookups table
CREATE TABLE IF NOT EXISTS carrier_lookups (
  id            TEXT PRIMARY KEY,
  tenant_id     TEXT NOT NULL,
  phone_number   TEXT NOT NULL,
  carrier        TEXT,
  lata           TEXT,
  ocn            TEXT,
  provider       TEXT NOT NULL,
  cached         BOOLEAN NOT NULL DEFAULT FALSE,
  cached_until   TIMESTAMPTZ,
  metadata       JSONB,
  created_at     TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at     TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_carrier_lookups_tenant_phone ON carrier_lookups(tenant_id, phone_number);
CREATE INDEX IF NOT EXISTS idx_carrier_lookups_tenant_id ON carrier_lookups(tenant_id);
CREATE INDEX IF NOT EXISTS idx_carrier_lookups_phone_number ON carrier_lookups(phone_number);
CREATE INDEX IF NOT EXISTS idx_carrier_lookups_lata ON carrier_lookups(lata);
CREATE INDEX IF NOT EXISTS idx_carrier_lookups_ocn ON carrier_lookups(ocn);

ALTER TABLE carrier_lookups
  ADD CONSTRAINT fk_carrier_lookups_tenant
  FOREIGN KEY (tenant_id) REFERENCES tenants(id) ON DELETE CASCADE;

