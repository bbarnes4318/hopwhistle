/* eslint-disable no-console, no-undef */
import { randomUUID } from 'crypto';

import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

const TARGET_PHONE = process.env.PHONE || '+19548492066';

async function main() {
  console.log(`Creating test call for ${TARGET_PHONE}...`);

  try {
    // 1. Get or Create Tenant
    let tenant = await prisma.tenant.findFirst();
    if (!tenant) {
      console.log('Creating Test Tenant...');
      tenant = await prisma.tenant.create({
        data: {
          name: 'Test Tenant',
          slug: 'test-tenant-' + Date.now(),
          status: 'ACTIVE',
        },
      });
    }
    console.log('Using Tenant:', tenant.id);

    // 2. Get or Create Publisher
    let publisher = await prisma.publisher.findFirst({ where: { tenantId: tenant.id } });
    if (!publisher) {
      console.log('Creating Test Publisher...');
      publisher = await prisma.publisher.create({
        data: {
          name: 'Test Publisher',
          code: 'PUB-TEST',
          tenantId: tenant.id,
          status: 'ACTIVE',
        },
      });
    }
    console.log('Using Publisher:', publisher.id);

    // 3. Create Active Campaign
    console.log('Creating Test Campaign...');
    const campaign = await prisma.campaign.create({
      data: {
        name: 'Test Dialer Campaign ' + new Date().toISOString(),
        tenantId: tenant.id,
        publisherId: publisher.id,
        status: 'ACTIVE',
        routingMode: 'STATIC',
      },
    });
    console.log('Created Campaign:', campaign.id);

    // 4. Create Lead (Raw SQL to bypass potential Prisma client issues)
    console.log('Inserting Lead via Raw SQL...');
    const leadId = randomUUID();

    // Note: casting 'NEW'::"LeadStatus" requires the enum to be named exactly "LeadStatus" in Postgres
    await prisma.$executeRaw`
      INSERT INTO "leads" (
        "id", "tenantId", "campaignId", "phoneNumber", "status",
        "firstName", "lastName", "createdAt", "updatedAt"
      ) VALUES (
        ${leadId}, ${tenant.id}, ${campaign.id}, ${TARGET_PHONE}, 'NEW'::"LeadStatus",
        'Test', 'User', NOW(), NOW()
      );
    `;

    console.log('✅ SUCCESS! Lead created:', leadId);
    console.log('Monitor logs: docker compose logs -f worker');
  } catch (e) {
    console.error('Error creating test data:', e);
  } finally {
    await prisma.$disconnect();
  }
}

main().catch(console.error);
