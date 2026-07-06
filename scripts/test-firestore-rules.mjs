/**
 * Verifies Kaleidoscope Firestore rules block unauthenticated reads.
 * Run: npm install && npm run test:firestore-rules
 */
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';
import {
  initializeTestEnvironment,
  assertFails,
  assertSucceeds,
} from '@firebase/rules-unit-testing';

const projectId = 'se-kaleidoscope-collaborative-test';
const rules = readFileSync(resolve('firestore.rules'), 'utf8');

const testEnv = await initializeTestEnvironment({
  projectId,
  firestore: { rules },
});

try {
  const unauthed = testEnv.unauthenticatedContext();
  const db = unauthed.firestore();

  await assertFails(db.collection('User').get());
  await assertFails(db.collection('ProfileData').get());
  await assertFails(db.collection('Favorites').get());
  await assertFails(db.doc('User/some-user-id').get());

  const authed = testEnv.authenticatedContext('user-abc', {
    email: 'student@bu.edu',
  });
  const authedDb = authed.firestore();

  await assertSucceeds(
    authedDb.doc('User/user-abc').set({
      email: 'student@bu.edu',
      first_name: 'Test',
      last_name: 'User',
    }),
  );

  await assertFails(
    authedDb.doc('User/user-abc').set({
      email: 'student@bu.edu',
      password: 'secret',
    }),
  );

  await assertFails(authedDb.collection('User').get());

  console.log('Firestore rules tests passed.');
} finally {
  await testEnv.cleanup();
}
