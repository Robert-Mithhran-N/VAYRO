import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('Seeding initial development health record...');
  const record = await prisma.devHealthRecord.upsert({
    where: { id: 1 },
    update: {
      status: 'HEALTHY',
      details: 'VAYRO foundation database seed verification',
    },
    create: {
      id: 1,
      service: 'vayro-backend',
      checkType: 'initial_migration_seed',
      status: 'HEALTHY',
      details: 'VAYRO foundation database seed verification',
    },
  });

  console.log('Seeded DevHealthRecord:', record);
}

main()
  .catch((e) => {
    console.error('Error during database seed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });

