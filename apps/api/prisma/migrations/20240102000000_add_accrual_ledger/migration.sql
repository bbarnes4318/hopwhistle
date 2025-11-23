-- Create accrual_ledger table
CREATE TABLE IF NOT EXISTS accrual_ledger (
  id              TEXT PRIMARY KEY,
  tenant_id       TEXT NOT NULL,
  billing_account_id TEXT NOT NULL,
  publisher_id    TEXT,
  buyer_id        TEXT,
  call_id         TEXT,
  type            TEXT NOT NULL,
  amount          NUMERIC(10, 4) NOT NULL,
  currency        TEXT NOT NULL DEFAULT 'USD',
  description     TEXT NOT NULL,
  period_date     TIMESTAMPTZ NOT NULL,
  closed          BOOLEAN NOT NULL DEFAULT FALSE,
  closed_at       TIMESTAMPTZ,
  invoice_id      TEXT,
  metadata        JSONB,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at      TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_accrual_ledger_tenant_id ON accrual_ledger(tenant_id);
CREATE INDEX IF NOT EXISTS idx_accrual_ledger_billing_account_id ON accrual_ledger(billing_account_id);
CREATE INDEX IF NOT EXISTS idx_accrual_ledger_period_date ON accrual_ledger(period_date);
CREATE INDEX IF NOT EXISTS idx_accrual_ledger_closed ON accrual_ledger(closed);
CREATE INDEX IF NOT EXISTS idx_accrual_ledger_publisher_id ON accrual_ledger(publisher_id);
CREATE INDEX IF NOT EXISTS idx_accrual_ledger_buyer_id ON accrual_ledger(buyer_id);
CREATE INDEX IF NOT EXISTS idx_accrual_ledger_call_id ON accrual_ledger(call_id);

-- Add foreign key constraints
ALTER TABLE accrual_ledger
  ADD CONSTRAINT fk_accrual_ledger_billing_account
  FOREIGN KEY (billing_account_id) REFERENCES billing_accounts(id) ON DELETE CASCADE;

ALTER TABLE accrual_ledger
  ADD CONSTRAINT fk_accrual_ledger_invoice
  FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE SET NULL;

ALTER TABLE accrual_ledger
  ADD CONSTRAINT fk_accrual_ledger_call
  FOREIGN KEY (call_id) REFERENCES calls(id) ON DELETE SET NULL;

-- Add Stripe fields to billing_accounts (if not exists)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'billing_accounts' AND column_name = 'stripe_customer_id'
  ) THEN
    ALTER TABLE billing_accounts ADD COLUMN stripe_customer_id TEXT;
  END IF;
  
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name = 'billing_accounts' AND column_name = 'stripe_connect_account_id'
  ) THEN
    ALTER TABLE billing_accounts ADD COLUMN stripe_connect_account_id TEXT;
  END IF;
END $$;

