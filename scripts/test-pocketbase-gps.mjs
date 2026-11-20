import { randomBytes } from 'node:crypto';

const baseUrl = (process.env.POCKETBASE_URL || 'http://127.0.0.1:8090').replace(/\/$/, '');
const adminEmail = process.env.POCKETBASE_SUPERUSER_EMAIL;
const adminPassword = process.env.POCKETBASE_SUPERUSER_PASSWORD;
if (!adminEmail || !adminPassword) {
  throw new Error('Set POCKETBASE_SUPERUSER_EMAIL and POCKETBASE_SUPERUSER_PASSWORD for local integration tests.');
}

async function request(path, { token, method = 'GET', body } = {}) {
  const response = await fetch(`${baseUrl}${path}`, {
    method,
    headers: {
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...(body ? { 'Content-Type': 'application/json' } : {}),
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  const text = await response.text();
  let data;
  try { data = text ? JSON.parse(text) : {}; } catch { data = text; }
  return { status: response.status, data };
}

async function expectStatus(label, result, accepted) {
  if (!accepted.includes(result.status)) {
    throw new Error(`${label}: expected HTTP ${accepted.join(' or ')}, got ${result.status}: ${JSON.stringify(result.data)}`);
  }
  console.log(`✓ ${label} (${result.status})`);
  return result;
}

async function create(collection, body, token) {
  const result = await request(`/api/collections/${collection}/records`, { method: 'POST', token, body });
  expectStatus(`create ${collection}`, result, [200]);
  return result.data;
}

async function deleteRecord(collection, id, token) {
  if (!id) return;
  await request(`/api/collections/${collection}/records/${id}`, { method: 'DELETE', token });
}

const adminAuth = await request('/api/collections/_superusers/auth-with-password', {
  method: 'POST', body: { identity: adminEmail, password: adminPassword },
});
expectStatus('authenticate local superuser', adminAuth, [200]);
const adminToken = adminAuth.data.token;

const suffix = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
const testPassword = randomBytes(24).toString('base64url');
const phoneTestPassword = randomBytes(24).toString('base64url');
let userId;
let phoneUserId;
let routeId;
let completionId;
const checkpointIds = [];
try {
  const user = await create('users', {
    email: `gps-test-${suffix}@example.test`,
    password: testPassword,
    passwordConfirm: testPassword,
    name: 'GPS Integration Test',
  });
  userId = user.id;

  const phoneIdentity = `+7999${String(Date.now()).slice(-7)}`;
  const phoneUser = await create('users', {
    phone: phoneIdentity,
    password: phoneTestPassword,
    passwordConfirm: phoneTestPassword,
    name: 'Phone Auth Test',
  });
  phoneUserId = phoneUser.id;
  const phoneLogin = await request('/api/collections/users/auth-with-password', {
    method: 'POST',
    body: { identity: phoneIdentity, password: phoneTestPassword },
  });
  expectStatus('register and authenticate by phone identity', phoneLogin, [200]);

  const login = await request('/api/collections/users/auth-with-password', {
    method: 'POST',
    body: { identity: `gps-test-${suffix}@example.test`, password: testPassword },
  });
  expectStatus('authenticate regular test user', login, [200]);
  const userToken = login.data.token;

  const route = await create('routes', {
    slug: `gps-test-${suffix}`,
    title: `ДЕМО · GPS integration test ${suffix}`,
    summary: 'Автоматическая тестовая запись, будет удалена после проверки.',
    description: 'DEMO TEST DATA — not a public city route.',
    distance_km: 0.2,
    estimated_minutes: 5,
    reward_points: 17,
    checkpoint_radius_m: 30,
    difficulty: 'easy',
    status: 'published',
  }, adminToken);
  routeId = route.id;

  const coordinates = [
    [55.7500, 86.0000],
    [55.7506, 86.0000],
    [55.7512, 86.0000],
  ];
  for (let index = 0; index < coordinates.length; index++) {
    const [latitude, longitude] = coordinates[index];
    const checkpoint = await create('route_checkpoints', {
      route: routeId,
      sequence: index + 1,
      title: index === 2 ? 'Демо финиш' : `Демо точка ${index + 1}`,
      description: 'Тестовая контрольная точка; координаты условные.',
      latitude,
      longitude,
      is_finish: index === 2,
    }, adminToken);
    checkpointIds.push(checkpoint.id);
  }

  const completion = await create('route_completions', {
    user: userId,
    route: routeId,
    status: 'in_progress',
    attempt_key: `gps-test-${suffix}-attempt`,
  }, userToken);
  completionId = completion.id;

  const checkpointPath = '/api/gorod/route-progress/checkpoint';
  const finishPath = '/api/gorod/route-progress/finish';
  const postGps = (path, index, accuracy = 5) => request(path, {
    method: 'POST', token: userToken,
    body: {
      completion_id: completionId,
      latitude: coordinates[index][0],
      longitude: coordinates[index][1],
      accuracy_m: accuracy,
    },
  });

  await expectStatus('reject inaccurate GPS', await postGps(checkpointPath, 0, 40), [400]);
  await expectStatus('reject skipped checkpoint', await postGps(checkpointPath, 1), [400]);
  await expectStatus('reject early finish', await postGps(finishPath, 2), [400]);

  const first = await postGps(checkpointPath, 0);
  expectStatus('accept first checkpoint', first, [200]);
  await expectStatus('reject replay at old checkpoint', await postGps(checkpointPath, 0), [400]);
  await new Promise((resolve) => setTimeout(resolve, 6000));
  expectStatus('accept second checkpoint in order', await postGps(checkpointPath, 1), [200]);
  await new Promise((resolve) => setTimeout(resolve, 6000));
  expectStatus('accept finish checkpoint in order', await postGps(checkpointPath, 2), [200]);
  await expectStatus('reject finish away from finish', await postGps(finishPath, 0), [400]);

  const finish = await postGps(finishPath, 2);
  expectStatus('complete route and award atomically', finish, [200]);
  if (finish.data.awarded_points !== 17) throw new Error(`Expected 17 points, got ${JSON.stringify(finish.data)}`);
  const replay = await postGps(finishPath, 2);
  expectStatus('make duplicate finish idempotent', replay, [200]);
  if (replay.data.repeated !== true) throw new Error('Duplicate finish did not return repeated=true.');

  await expectStatus('block direct balance edits', await request(`/api/collections/users/records/${userId}`, {
    method: 'PATCH', token: userToken, body: { points_balance: 9999 },
  }), [400, 403, 404]);
  await expectStatus('block direct visit creation', await request('/api/collections/route_checkpoint_visits/records', {
    method: 'POST', token: userToken,
    body: { completion: completionId, checkpoint: checkpointIds[0], latitude: coordinates[0][0], longitude: coordinates[0][1], accuracy_m: 5, visited_at: new Date().toISOString() },
  }), [400, 403, 404]);

  const profile = await request(`/api/collections/users/records/${userId}`, { token: userToken });
  expectStatus('read own final profile', profile, [200]);
  if (profile.data.points_balance !== 17 || profile.data.tasks_completed !== 1) {
    throw new Error(`Unexpected profile reward counters: ${JSON.stringify(profile.data)}`);
  }
  const visits = await request(`/api/collections/route_checkpoint_visits/records?filter=${encodeURIComponent(`completion="${completionId}"`)}&perPage=50`, { token: userToken });
  expectStatus('read own checkpoint visits', visits, [200]);
  if (visits.data.totalItems !== 3) throw new Error(`Expected exactly 3 checkpoint visits, got ${visits.data.totalItems}`);
  const transactions = await request(`/api/collections/point_transactions/records?filter=${encodeURIComponent(`completion="${completionId}"`)}&perPage=50`, { token: userToken });
  expectStatus('read own point transaction', transactions, [200]);
  if (transactions.data.totalItems !== 1) throw new Error(`Expected exactly 1 reward transaction, got ${transactions.data.totalItems}`);
  console.log('\nPocketBase GPS integration checks passed. Coordinates were simulated over HTTP; no physical GPS was used.');
} finally {
  if (completionId) {
    const lists = await Promise.all([
      request(`/api/collections/point_transactions/records?filter=${encodeURIComponent(`completion="${completionId}"`)}&perPage=100`, { token: adminToken }),
      request(`/api/collections/route_checkpoint_visits/records?filter=${encodeURIComponent(`completion="${completionId}"`)}&perPage=100`, { token: adminToken }),
    ]);
    for (const record of lists[0].data?.items || []) await deleteRecord('point_transactions', record.id, adminToken);
    for (const record of lists[1].data?.items || []) await deleteRecord('route_checkpoint_visits', record.id, adminToken);
    await deleteRecord('route_completions', completionId, adminToken);
  }
  for (const checkpointId of checkpointIds) await deleteRecord('route_checkpoints', checkpointId, adminToken);
  await deleteRecord('routes', routeId, adminToken);
  await deleteRecord('users', userId, adminToken);
  await deleteRecord('users', phoneUserId, adminToken);
}
