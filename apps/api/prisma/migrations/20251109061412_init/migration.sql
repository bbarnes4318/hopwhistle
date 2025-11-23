-- CreateEnum
CREATE TYPE "TenantStatus" AS ENUM ('ACTIVE', 'SUSPENDED', 'INACTIVE');

-- CreateEnum
CREATE TYPE "UserStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "ApiKeyStatus" AS ENUM ('ACTIVE', 'REVOKED', 'EXPIRED');

-- CreateEnum
CREATE TYPE "PhoneNumberStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'PORTING', 'SUSPENDED');

-- CreateEnum
CREATE TYPE "CarrierStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "TrunkType" AS ENUM ('SIP', 'IAX2', 'WEBRTC');

-- CreateEnum
CREATE TYPE "TrunkStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'MAINTENANCE');

-- CreateEnum
CREATE TYPE "CallerIdPoolStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "CampaignStatus" AS ENUM ('ACTIVE', 'PAUSED', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "PublisherStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "BuyerStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "BuyerEndpointType" AS ENUM ('SIP', 'PSTN', 'WEBRTC');

-- CreateEnum
CREATE TYPE "BuyerEndpointStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'FAILED');

-- CreateEnum
CREATE TYPE "FlowStatus" AS ENUM ('DRAFT', 'ACTIVE', 'ARCHIVED');

-- CreateEnum
CREATE TYPE "NodeType" AS ENUM ('IVR', 'QUEUE', 'BUYER_FORWARD', 'VOICEMAIL', 'HANGUP', 'RECORDING', 'TRANSFER', 'CONDITIONAL');

-- CreateEnum
CREATE TYPE "CallStatus" AS ENUM ('INITIATED', 'RINGING', 'ANSWERED', 'COMPLETED', 'FAILED', 'BUSY', 'NO_ANSWER', 'CANCELLED');

-- CreateEnum
CREATE TYPE "CallDirection" AS ENUM ('INBOUND', 'OUTBOUND');

-- CreateEnum
CREATE TYPE "CallLegStatus" AS ENUM ('INITIATED', 'RINGING', 'ANSWERED', 'COMPLETED', 'FAILED', 'BUSY', 'NO_ANSWER', 'CANCELLED');

-- CreateEnum
CREATE TYPE "CallLegDirection" AS ENUM ('INBOUND', 'OUTBOUND');

-- CreateEnum
CREATE TYPE "RecordingStatus" AS ENUM ('PROCESSING', 'COMPLETED', 'FAILED');

-- CreateEnum
CREATE TYPE "BillingAccountStatus" AS ENUM ('ACTIVE', 'SUSPENDED', 'CLOSED');

-- CreateEnum
CREATE TYPE "RateCardStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "InvoiceStatus" AS ENUM ('DRAFT', 'SENT', 'PAID', 'OVERDUE', 'CANCELLED');

-- CreateEnum
CREATE TYPE "BalanceType" AS ENUM ('AVAILABLE', 'PENDING', 'HELD');

-- CreateEnum
CREATE TYPE "PayoutStatus" AS ENUM ('PENDING', 'PROCESSING', 'COMPLETED', 'FAILED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "WebhookStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'FAILED');

-- CreateEnum
CREATE TYPE "DncListType" AS ENUM ('GLOBAL', 'CAMPAIGN', 'CUSTOM');

-- CreateEnum
CREATE TYPE "DncListStatus" AS ENUM ('ACTIVE', 'INACTIVE');

-- CreateEnum
CREATE TYPE "ConsentProvider" AS ENUM ('TRUSTEDFORM', 'JORNAYA', 'CUSTOM');

-- CreateEnum
CREATE TYPE "ConsentStatus" AS ENUM ('PENDING', 'VERIFIED', 'INVALID', 'EXPIRED');

-- CreateTable
CREATE TABLE "tenants" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "domain" TEXT,
    "status" "TenantStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tenants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "passwordHash" TEXT NOT NULL,
    "firstName" TEXT,
    "lastName" TEXT,
    "status" "UserStatus" NOT NULL DEFAULT 'ACTIVE',
    "lastLoginAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "roles" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "permissions" JSONB NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_roles" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "api_keys" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "keyHash" TEXT NOT NULL,
    "prefix" TEXT NOT NULL,
    "status" "ApiKeyStatus" NOT NULL DEFAULT 'ACTIVE',
    "lastUsedAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "api_keys_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "phone_numbers" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "number" TEXT NOT NULL,
    "carrierId" TEXT,
    "trunkId" TEXT,
    "status" "PhoneNumberStatus" NOT NULL DEFAULT 'ACTIVE',
    "capabilities" JSONB,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "phone_numbers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "carriers" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "status" "CarrierStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "carriers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "trunks" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "carrierId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "TrunkType" NOT NULL,
    "host" TEXT NOT NULL,
    "port" INTEGER NOT NULL,
    "username" TEXT,
    "password" TEXT,
    "status" "TrunkStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "trunks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "caller_id_pools" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "status" "CallerIdPoolStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "caller_id_pools_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "caller_id_pool_phone_numbers" (
    "id" TEXT NOT NULL,
    "callerIdPoolId" TEXT NOT NULL,
    "phoneNumberId" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "caller_id_pool_phone_numbers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "campaigns" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "publisherId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "status" "CampaignStatus" NOT NULL DEFAULT 'ACTIVE',
    "callerIdPoolId" TEXT,
    "flowId" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "campaigns_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "publishers" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "status" "PublisherStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "publishers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "buyers" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "publisherId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "status" "BuyerStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "buyers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "buyer_endpoints" (
    "id" TEXT NOT NULL,
    "buyerId" TEXT NOT NULL,
    "phoneNumberId" TEXT,
    "type" "BuyerEndpointType" NOT NULL,
    "destination" TEXT NOT NULL,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "status" "BuyerEndpointStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "buyer_endpoints_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "flows" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "status" "FlowStatus" NOT NULL DEFAULT 'DRAFT',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "flows_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "flow_versions" (
    "id" TEXT NOT NULL,
    "flowId" TEXT NOT NULL,
    "version" INTEGER NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT false,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "flow_versions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "nodes" (
    "id" TEXT NOT NULL,
    "flowVersionId" TEXT NOT NULL,
    "type" "NodeType" NOT NULL,
    "name" TEXT NOT NULL,
    "config" JSONB NOT NULL,
    "position" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "nodes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "edges" (
    "id" TEXT NOT NULL,
    "flowVersionId" TEXT NOT NULL,
    "fromNodeId" TEXT NOT NULL,
    "toNodeId" TEXT NOT NULL,
    "condition" TEXT,
    "priority" INTEGER NOT NULL DEFAULT 0,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "edges_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "calls" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "campaignId" TEXT,
    "fromNumberId" TEXT,
    "toNumber" TEXT NOT NULL,
    "callSid" TEXT NOT NULL,
    "status" "CallStatus" NOT NULL,
    "direction" "CallDirection" NOT NULL,
    "duration" INTEGER,
    "cost" DECIMAL(10,4),
    "metadata" JSONB,
    "createdById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "startedAt" TIMESTAMP(3),
    "answeredAt" TIMESTAMP(3),
    "endedAt" TIMESTAMP(3),

    CONSTRAINT "calls_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "call_legs" (
    "id" TEXT NOT NULL,
    "callId" TEXT NOT NULL,
    "phoneNumberId" TEXT,
    "legSid" TEXT NOT NULL,
    "status" "CallLegStatus" NOT NULL,
    "direction" "CallLegDirection" NOT NULL,
    "duration" INTEGER,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,
    "startedAt" TIMESTAMP(3),
    "answeredAt" TIMESTAMP(3),
    "endedAt" TIMESTAMP(3),

    CONSTRAINT "call_legs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cdrs" (
    "id" TEXT NOT NULL,
    "callId" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "fromNumber" TEXT NOT NULL,
    "toNumber" TEXT NOT NULL,
    "duration" INTEGER NOT NULL,
    "billableDuration" INTEGER NOT NULL,
    "cost" DECIMAL(10,4) NOT NULL,
    "rate" DECIMAL(10,6),
    "direction" "CallDirection" NOT NULL,
    "status" "CallStatus" NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "cdrs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "recordings" (
    "id" TEXT NOT NULL,
    "callId" TEXT NOT NULL,
    "legId" TEXT,
    "url" TEXT NOT NULL,
    "storageKey" TEXT,
    "duration" INTEGER,
    "format" TEXT NOT NULL DEFAULT 'wav',
    "size" BIGINT,
    "status" "RecordingStatus" NOT NULL DEFAULT 'PROCESSING',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "recordings_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "transcriptions" (
    "id" TEXT NOT NULL,
    "callId" TEXT NOT NULL,
    "recordingId" TEXT,
    "text" TEXT NOT NULL,
    "confidence" DECIMAL(5,4),
    "language" TEXT NOT NULL DEFAULT 'en',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "transcriptions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tags" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "color" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "call_tags" (
    "id" TEXT NOT NULL,
    "callId" TEXT NOT NULL,
    "tagId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "call_tags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "billing_accounts" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "status" "BillingAccountStatus" NOT NULL DEFAULT 'ACTIVE',
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "billing_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rate_cards" (
    "id" TEXT NOT NULL,
    "billingAccountId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "effectiveFrom" TIMESTAMP(3) NOT NULL,
    "effectiveTo" TIMESTAMP(3),
    "status" "RateCardStatus" NOT NULL DEFAULT 'ACTIVE',
    "rates" JSONB NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "rate_cards_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoices" (
    "id" TEXT NOT NULL,
    "billingAccountId" TEXT NOT NULL,
    "invoiceNumber" TEXT NOT NULL,
    "status" "InvoiceStatus" NOT NULL DEFAULT 'DRAFT',
    "periodStart" TIMESTAMP(3) NOT NULL,
    "periodEnd" TIMESTAMP(3) NOT NULL,
    "subtotal" DECIMAL(10,2) NOT NULL,
    "tax" DECIMAL(10,2) NOT NULL DEFAULT 0,
    "total" DECIMAL(10,2) NOT NULL,
    "dueDate" TIMESTAMP(3) NOT NULL,
    "paidAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "invoices_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "invoice_lines" (
    "id" TEXT NOT NULL,
    "invoiceId" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "quantity" DECIMAL(10,2) NOT NULL,
    "unitPrice" DECIMAL(10,4) NOT NULL,
    "total" DECIMAL(10,2) NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "invoice_lines_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "balances" (
    "id" TEXT NOT NULL,
    "billingAccountId" TEXT NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "type" "BalanceType" NOT NULL,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "balances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payouts" (
    "id" TEXT NOT NULL,
    "billingAccountId" TEXT NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "status" "PayoutStatus" NOT NULL DEFAULT 'PENDING',
    "method" TEXT NOT NULL,
    "reference" TEXT,
    "processedAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payouts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "webhooks" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "events" TEXT[],
    "secret" TEXT NOT NULL,
    "status" "WebhookStatus" NOT NULL DEFAULT 'ACTIVE',
    "lastTriggeredAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "webhooks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "events" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "type" TEXT NOT NULL,
    "entityType" TEXT,
    "entityId" TEXT,
    "payload" JSONB NOT NULL,
    "processed" BOOLEAN NOT NULL DEFAULT false,
    "processedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "events_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "userId" TEXT,
    "action" TEXT NOT NULL,
    "entityType" TEXT NOT NULL,
    "entityId" TEXT NOT NULL,
    "changes" JSONB,
    "ipAddress" TEXT,
    "userAgent" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "feature_flags" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "key" TEXT NOT NULL,
    "value" JSONB NOT NULL,
    "description" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "feature_flags_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dnc_lists" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "type" "DncListType" NOT NULL,
    "status" "DncListStatus" NOT NULL DEFAULT 'ACTIVE',
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "dnc_lists_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "dnc_list_entries" (
    "id" TEXT NOT NULL,
    "dncListId" TEXT NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "reason" TEXT,
    "source" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "dnc_list_entries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "consent_tokens" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "callId" TEXT,
    "phoneNumber" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "provider" "ConsentProvider" NOT NULL,
    "status" "ConsentStatus" NOT NULL DEFAULT 'PENDING',
    "verifiedAt" TIMESTAMP(3),
    "expiresAt" TIMESTAMP(3),
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "consent_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stir_shaken_status" (
    "id" TEXT NOT NULL,
    "callId" TEXT NOT NULL,
    "attestation" TEXT,
    "verified" BOOLEAN NOT NULL DEFAULT false,
    "error" TEXT,
    "metadata" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "stir_shaken_status_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "tenants_slug_key" ON "tenants"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "tenants_domain_key" ON "tenants"("domain");

-- CreateIndex
CREATE INDEX "tenants_slug_idx" ON "tenants"("slug");

-- CreateIndex
CREATE INDEX "tenants_status_idx" ON "tenants"("status");

-- CreateIndex
CREATE INDEX "users_tenantId_email_idx" ON "users"("tenantId", "email");

-- CreateIndex
CREATE INDEX "users_tenantId_status_idx" ON "users"("tenantId", "status");

-- CreateIndex
CREATE UNIQUE INDEX "users_tenantId_email_key" ON "users"("tenantId", "email");

-- CreateIndex
CREATE UNIQUE INDEX "roles_name_key" ON "roles"("name");

-- CreateIndex
CREATE INDEX "user_roles_userId_idx" ON "user_roles"("userId");

-- CreateIndex
CREATE INDEX "user_roles_roleId_idx" ON "user_roles"("roleId");

-- CreateIndex
CREATE UNIQUE INDEX "user_roles_userId_roleId_key" ON "user_roles"("userId", "roleId");

-- CreateIndex
CREATE UNIQUE INDEX "api_keys_keyHash_key" ON "api_keys"("keyHash");

-- CreateIndex
CREATE INDEX "api_keys_tenantId_idx" ON "api_keys"("tenantId");

-- CreateIndex
CREATE INDEX "api_keys_keyHash_idx" ON "api_keys"("keyHash");

-- CreateIndex
CREATE INDEX "api_keys_status_idx" ON "api_keys"("status");

-- CreateIndex
CREATE INDEX "phone_numbers_tenantId_number_idx" ON "phone_numbers"("tenantId", "number");

-- CreateIndex
CREATE INDEX "phone_numbers_tenantId_status_idx" ON "phone_numbers"("tenantId", "status");

-- CreateIndex
CREATE INDEX "phone_numbers_carrierId_idx" ON "phone_numbers"("carrierId");

-- CreateIndex
CREATE INDEX "phone_numbers_trunkId_idx" ON "phone_numbers"("trunkId");

-- CreateIndex
CREATE UNIQUE INDEX "phone_numbers_tenantId_number_key" ON "phone_numbers"("tenantId", "number");

-- CreateIndex
CREATE INDEX "carriers_tenantId_idx" ON "carriers"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "carriers_tenantId_code_key" ON "carriers"("tenantId", "code");

-- CreateIndex
CREATE INDEX "trunks_tenantId_idx" ON "trunks"("tenantId");

-- CreateIndex
CREATE INDEX "trunks_carrierId_idx" ON "trunks"("carrierId");

-- CreateIndex
CREATE INDEX "trunks_status_idx" ON "trunks"("status");

-- CreateIndex
CREATE INDEX "caller_id_pools_tenantId_idx" ON "caller_id_pools"("tenantId");

-- CreateIndex
CREATE INDEX "caller_id_pool_phone_numbers_callerIdPoolId_idx" ON "caller_id_pool_phone_numbers"("callerIdPoolId");

-- CreateIndex
CREATE INDEX "caller_id_pool_phone_numbers_phoneNumberId_idx" ON "caller_id_pool_phone_numbers"("phoneNumberId");

-- CreateIndex
CREATE UNIQUE INDEX "caller_id_pool_phone_numbers_callerIdPoolId_phoneNumberId_key" ON "caller_id_pool_phone_numbers"("callerIdPoolId", "phoneNumberId");

-- CreateIndex
CREATE INDEX "campaigns_tenantId_idx" ON "campaigns"("tenantId");

-- CreateIndex
CREATE INDEX "campaigns_publisherId_idx" ON "campaigns"("publisherId");

-- CreateIndex
CREATE INDEX "campaigns_status_idx" ON "campaigns"("status");

-- CreateIndex
CREATE INDEX "publishers_tenantId_idx" ON "publishers"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "publishers_tenantId_code_key" ON "publishers"("tenantId", "code");

-- CreateIndex
CREATE INDEX "buyers_tenantId_idx" ON "buyers"("tenantId");

-- CreateIndex
CREATE INDEX "buyers_publisherId_idx" ON "buyers"("publisherId");

-- CreateIndex
CREATE UNIQUE INDEX "buyers_tenantId_publisherId_code_key" ON "buyers"("tenantId", "publisherId", "code");

-- CreateIndex
CREATE INDEX "buyer_endpoints_buyerId_idx" ON "buyer_endpoints"("buyerId");

-- CreateIndex
CREATE INDEX "buyer_endpoints_phoneNumberId_idx" ON "buyer_endpoints"("phoneNumberId");

-- CreateIndex
CREATE INDEX "buyer_endpoints_status_idx" ON "buyer_endpoints"("status");

-- CreateIndex
CREATE INDEX "flows_tenantId_idx" ON "flows"("tenantId");

-- CreateIndex
CREATE INDEX "flows_status_idx" ON "flows"("status");

-- CreateIndex
CREATE INDEX "flow_versions_flowId_idx" ON "flow_versions"("flowId");

-- CreateIndex
CREATE INDEX "flow_versions_flowId_isActive_idx" ON "flow_versions"("flowId", "isActive");

-- CreateIndex
CREATE UNIQUE INDEX "flow_versions_flowId_version_key" ON "flow_versions"("flowId", "version");

-- CreateIndex
CREATE INDEX "nodes_flowVersionId_idx" ON "nodes"("flowVersionId");

-- CreateIndex
CREATE INDEX "nodes_flowVersionId_type_idx" ON "nodes"("flowVersionId", "type");

-- CreateIndex
CREATE INDEX "edges_flowVersionId_idx" ON "edges"("flowVersionId");

-- CreateIndex
CREATE INDEX "edges_fromNodeId_idx" ON "edges"("fromNodeId");

-- CreateIndex
CREATE INDEX "edges_toNodeId_idx" ON "edges"("toNodeId");

-- CreateIndex
CREATE UNIQUE INDEX "calls_callSid_key" ON "calls"("callSid");

-- CreateIndex
CREATE INDEX "calls_tenantId_idx" ON "calls"("tenantId");

-- CreateIndex
CREATE INDEX "calls_tenantId_createdAt_idx" ON "calls"("tenantId", "createdAt");

-- CreateIndex
CREATE INDEX "calls_campaignId_idx" ON "calls"("campaignId");

-- CreateIndex
CREATE INDEX "calls_callSid_idx" ON "calls"("callSid");

-- CreateIndex
CREATE INDEX "calls_status_idx" ON "calls"("status");

-- CreateIndex
CREATE INDEX "calls_direction_idx" ON "calls"("direction");

-- CreateIndex
CREATE UNIQUE INDEX "call_legs_legSid_key" ON "call_legs"("legSid");

-- CreateIndex
CREATE INDEX "call_legs_callId_idx" ON "call_legs"("callId");

-- CreateIndex
CREATE INDEX "call_legs_legSid_idx" ON "call_legs"("legSid");

-- CreateIndex
CREATE INDEX "call_legs_status_idx" ON "call_legs"("status");

-- CreateIndex
CREATE UNIQUE INDEX "cdrs_callId_key" ON "cdrs"("callId");

-- CreateIndex
CREATE INDEX "cdrs_tenantId_idx" ON "cdrs"("tenantId");

-- CreateIndex
CREATE INDEX "cdrs_tenantId_createdAt_idx" ON "cdrs"("tenantId", "createdAt");

-- CreateIndex
CREATE INDEX "cdrs_fromNumber_idx" ON "cdrs"("fromNumber");

-- CreateIndex
CREATE INDEX "cdrs_toNumber_idx" ON "cdrs"("toNumber");

-- CreateIndex
CREATE INDEX "cdrs_status_idx" ON "cdrs"("status");

-- CreateIndex
CREATE INDEX "recordings_callId_idx" ON "recordings"("callId");

-- CreateIndex
CREATE INDEX "recordings_status_idx" ON "recordings"("status");

-- CreateIndex
CREATE INDEX "transcriptions_callId_idx" ON "transcriptions"("callId");

-- CreateIndex
CREATE INDEX "transcriptions_recordingId_idx" ON "transcriptions"("recordingId");

-- CreateIndex
CREATE INDEX "tags_tenantId_idx" ON "tags"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "tags_tenantId_name_key" ON "tags"("tenantId", "name");

-- CreateIndex
CREATE INDEX "call_tags_callId_idx" ON "call_tags"("callId");

-- CreateIndex
CREATE INDEX "call_tags_tagId_idx" ON "call_tags"("tagId");

-- CreateIndex
CREATE UNIQUE INDEX "call_tags_callId_tagId_key" ON "call_tags"("callId", "tagId");

-- CreateIndex
CREATE INDEX "billing_accounts_tenantId_idx" ON "billing_accounts"("tenantId");

-- CreateIndex
CREATE INDEX "billing_accounts_status_idx" ON "billing_accounts"("status");

-- CreateIndex
CREATE INDEX "rate_cards_billingAccountId_idx" ON "rate_cards"("billingAccountId");

-- CreateIndex
CREATE INDEX "rate_cards_effectiveFrom_idx" ON "rate_cards"("effectiveFrom");

-- CreateIndex
CREATE INDEX "rate_cards_status_idx" ON "rate_cards"("status");

-- CreateIndex
CREATE UNIQUE INDEX "invoices_invoiceNumber_key" ON "invoices"("invoiceNumber");

-- CreateIndex
CREATE INDEX "invoices_billingAccountId_idx" ON "invoices"("billingAccountId");

-- CreateIndex
CREATE INDEX "invoices_invoiceNumber_idx" ON "invoices"("invoiceNumber");

-- CreateIndex
CREATE INDEX "invoices_status_idx" ON "invoices"("status");

-- CreateIndex
CREATE INDEX "invoices_dueDate_idx" ON "invoices"("dueDate");

-- CreateIndex
CREATE INDEX "invoice_lines_invoiceId_idx" ON "invoice_lines"("invoiceId");

-- CreateIndex
CREATE INDEX "balances_billingAccountId_idx" ON "balances"("billingAccountId");

-- CreateIndex
CREATE INDEX "balances_type_idx" ON "balances"("type");

-- CreateIndex
CREATE INDEX "payouts_billingAccountId_idx" ON "payouts"("billingAccountId");

-- CreateIndex
CREATE INDEX "payouts_status_idx" ON "payouts"("status");

-- CreateIndex
CREATE INDEX "webhooks_tenantId_idx" ON "webhooks"("tenantId");

-- CreateIndex
CREATE INDEX "webhooks_status_idx" ON "webhooks"("status");

-- CreateIndex
CREATE INDEX "events_tenantId_idx" ON "events"("tenantId");

-- CreateIndex
CREATE INDEX "events_tenantId_createdAt_idx" ON "events"("tenantId", "createdAt");

-- CreateIndex
CREATE INDEX "events_type_idx" ON "events"("type");

-- CreateIndex
CREATE INDEX "events_entityType_entityId_idx" ON "events"("entityType", "entityId");

-- CreateIndex
CREATE INDEX "events_processed_idx" ON "events"("processed");

-- CreateIndex
CREATE INDEX "audit_logs_tenantId_idx" ON "audit_logs"("tenantId");

-- CreateIndex
CREATE INDEX "audit_logs_tenantId_createdAt_idx" ON "audit_logs"("tenantId", "createdAt");

-- CreateIndex
CREATE INDEX "audit_logs_entityType_entityId_idx" ON "audit_logs"("entityType", "entityId");

-- CreateIndex
CREATE INDEX "audit_logs_userId_idx" ON "audit_logs"("userId");

-- CreateIndex
CREATE INDEX "feature_flags_tenantId_idx" ON "feature_flags"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "feature_flags_tenantId_key_key" ON "feature_flags"("tenantId", "key");

-- CreateIndex
CREATE INDEX "dnc_lists_tenantId_idx" ON "dnc_lists"("tenantId");

-- CreateIndex
CREATE INDEX "dnc_lists_type_idx" ON "dnc_lists"("type");

-- CreateIndex
CREATE INDEX "dnc_list_entries_dncListId_idx" ON "dnc_list_entries"("dncListId");

-- CreateIndex
CREATE INDEX "dnc_list_entries_phoneNumber_idx" ON "dnc_list_entries"("phoneNumber");

-- CreateIndex
CREATE UNIQUE INDEX "dnc_list_entries_dncListId_phoneNumber_key" ON "dnc_list_entries"("dncListId", "phoneNumber");

-- CreateIndex
CREATE UNIQUE INDEX "consent_tokens_token_key" ON "consent_tokens"("token");

-- CreateIndex
CREATE INDEX "consent_tokens_tenantId_idx" ON "consent_tokens"("tenantId");

-- CreateIndex
CREATE INDEX "consent_tokens_phoneNumber_idx" ON "consent_tokens"("phoneNumber");

-- CreateIndex
CREATE INDEX "consent_tokens_token_idx" ON "consent_tokens"("token");

-- CreateIndex
CREATE INDEX "consent_tokens_status_idx" ON "consent_tokens"("status");

-- CreateIndex
CREATE UNIQUE INDEX "stir_shaken_status_callId_key" ON "stir_shaken_status"("callId");

-- CreateIndex
CREATE INDEX "stir_shaken_status_callId_idx" ON "stir_shaken_status"("callId");

-- CreateIndex
CREATE INDEX "stir_shaken_status_verified_idx" ON "stir_shaken_status"("verified");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "api_keys" ADD CONSTRAINT "api_keys_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "phone_numbers" ADD CONSTRAINT "phone_numbers_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "phone_numbers" ADD CONSTRAINT "phone_numbers_carrierId_fkey" FOREIGN KEY ("carrierId") REFERENCES "carriers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "phone_numbers" ADD CONSTRAINT "phone_numbers_trunkId_fkey" FOREIGN KEY ("trunkId") REFERENCES "trunks"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "carriers" ADD CONSTRAINT "carriers_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trunks" ADD CONSTRAINT "trunks_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "trunks" ADD CONSTRAINT "trunks_carrierId_fkey" FOREIGN KEY ("carrierId") REFERENCES "carriers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "caller_id_pools" ADD CONSTRAINT "caller_id_pools_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "caller_id_pool_phone_numbers" ADD CONSTRAINT "caller_id_pool_phone_numbers_callerIdPoolId_fkey" FOREIGN KEY ("callerIdPoolId") REFERENCES "caller_id_pools"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "caller_id_pool_phone_numbers" ADD CONSTRAINT "caller_id_pool_phone_numbers_phoneNumberId_fkey" FOREIGN KEY ("phoneNumberId") REFERENCES "phone_numbers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_publisherId_fkey" FOREIGN KEY ("publisherId") REFERENCES "publishers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_callerIdPoolId_fkey" FOREIGN KEY ("callerIdPoolId") REFERENCES "caller_id_pools"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "campaigns" ADD CONSTRAINT "campaigns_flowId_fkey" FOREIGN KEY ("flowId") REFERENCES "flows"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "publishers" ADD CONSTRAINT "publishers_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "buyers" ADD CONSTRAINT "buyers_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "buyers" ADD CONSTRAINT "buyers_publisherId_fkey" FOREIGN KEY ("publisherId") REFERENCES "publishers"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "buyer_endpoints" ADD CONSTRAINT "buyer_endpoints_buyerId_fkey" FOREIGN KEY ("buyerId") REFERENCES "buyers"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "buyer_endpoints" ADD CONSTRAINT "buyer_endpoints_phoneNumberId_fkey" FOREIGN KEY ("phoneNumberId") REFERENCES "phone_numbers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "flows" ADD CONSTRAINT "flows_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "flow_versions" ADD CONSTRAINT "flow_versions_flowId_fkey" FOREIGN KEY ("flowId") REFERENCES "flows"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "nodes" ADD CONSTRAINT "nodes_flowVersionId_fkey" FOREIGN KEY ("flowVersionId") REFERENCES "flow_versions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "edges" ADD CONSTRAINT "edges_flowVersionId_fkey" FOREIGN KEY ("flowVersionId") REFERENCES "flow_versions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "edges" ADD CONSTRAINT "edges_fromNodeId_fkey" FOREIGN KEY ("fromNodeId") REFERENCES "nodes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "edges" ADD CONSTRAINT "edges_toNodeId_fkey" FOREIGN KEY ("toNodeId") REFERENCES "nodes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "calls" ADD CONSTRAINT "calls_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "calls" ADD CONSTRAINT "calls_campaignId_fkey" FOREIGN KEY ("campaignId") REFERENCES "campaigns"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "calls" ADD CONSTRAINT "calls_fromNumberId_fkey" FOREIGN KEY ("fromNumberId") REFERENCES "phone_numbers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "calls" ADD CONSTRAINT "calls_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "call_legs" ADD CONSTRAINT "call_legs_callId_fkey" FOREIGN KEY ("callId") REFERENCES "calls"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "call_legs" ADD CONSTRAINT "call_legs_phoneNumberId_fkey" FOREIGN KEY ("phoneNumberId") REFERENCES "phone_numbers"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cdrs" ADD CONSTRAINT "cdrs_callId_fkey" FOREIGN KEY ("callId") REFERENCES "calls"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "recordings" ADD CONSTRAINT "recordings_callId_fkey" FOREIGN KEY ("callId") REFERENCES "calls"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "transcriptions" ADD CONSTRAINT "transcriptions_callId_fkey" FOREIGN KEY ("callId") REFERENCES "calls"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tags" ADD CONSTRAINT "tags_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "call_tags" ADD CONSTRAINT "call_tags_callId_fkey" FOREIGN KEY ("callId") REFERENCES "calls"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "call_tags" ADD CONSTRAINT "call_tags_tagId_fkey" FOREIGN KEY ("tagId") REFERENCES "tags"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "billing_accounts" ADD CONSTRAINT "billing_accounts_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rate_cards" ADD CONSTRAINT "rate_cards_billingAccountId_fkey" FOREIGN KEY ("billingAccountId") REFERENCES "billing_accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoices" ADD CONSTRAINT "invoices_billingAccountId_fkey" FOREIGN KEY ("billingAccountId") REFERENCES "billing_accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "invoice_lines" ADD CONSTRAINT "invoice_lines_invoiceId_fkey" FOREIGN KEY ("invoiceId") REFERENCES "invoices"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "balances" ADD CONSTRAINT "balances_billingAccountId_fkey" FOREIGN KEY ("billingAccountId") REFERENCES "billing_accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payouts" ADD CONSTRAINT "payouts_billingAccountId_fkey" FOREIGN KEY ("billingAccountId") REFERENCES "billing_accounts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "webhooks" ADD CONSTRAINT "webhooks_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "events" ADD CONSTRAINT "events_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "feature_flags" ADD CONSTRAINT "feature_flags_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dnc_lists" ADD CONSTRAINT "dnc_lists_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dnc_list_entries" ADD CONSTRAINT "dnc_list_entries_dncListId_fkey" FOREIGN KEY ("dncListId") REFERENCES "dnc_lists"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "consent_tokens" ADD CONSTRAINT "consent_tokens_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;
