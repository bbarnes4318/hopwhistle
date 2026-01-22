import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('Adding DIALING to LeadStatus...');
  try {
    await prisma.$executeRawUnsafe(`ALTER TYPE "LeadStatus" ADD VALUE 'DIALING'`);
    console.log('✅ Added DIALING');
  } catch (e) {
    console.log('⚠️ Could not add DIALING (might exist):', e.message);
  }

  console.log('Adding RECYCLED to LeadStatus...');
  try {
    await prisma.$executeRawUnsafe(`ALTER TYPE "LeadStatus" ADD VALUE 'RECYCLED'`);
    console.log('✅ Added RECYCLED');
  } catch (e) {
    console.log('⚠️ Could not add RECYCLED (might exist):', e.message);
  }
}

main()
  .catch(e => console.error(e))
  .finally(async () => {
    await prisma.$disconnect();
  });
