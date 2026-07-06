/**
 * One-time Admin SDK script to remove plaintext password fields from User docs.
 *
 * Usage:
 *   export GOOGLE_APPLICATION_CREDENTIALS=/path/to/serviceAccountKey.json
 *   npm run purge:passwords
 */
import admin from 'firebase-admin';

if (!process.env.GOOGLE_APPLICATION_CREDENTIALS) {
  console.error('Set GOOGLE_APPLICATION_CREDENTIALS to a Firebase service account key.');
  process.exit(1);
}

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

const db = admin.firestore();

const snapshot = await db.collection('User').get();
let batch = db.batch();
let updated = 0;
let batchCount = 0;

for (const doc of snapshot.docs) {
  if (!Object.prototype.hasOwnProperty.call(doc.data(), 'password')) {
    continue;
  }

  batch.update(doc.ref, { password: admin.firestore.FieldValue.delete() });
  updated += 1;
  batchCount += 1;

  if (batchCount === 400) {
    await batch.commit();
    batch = db.batch();
    batchCount = 0;
  }
}

if (batchCount > 0) {
  await batch.commit();
}

console.log(`Removed password field from ${updated} User documents.`);
