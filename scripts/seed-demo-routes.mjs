const baseUrl = (process.env.POCKETBASE_URL || 'http://127.0.0.1:8090').replace(/\/$/, '');
const email = process.env.POCKETBASE_SUPERUSER_EMAIL;
const password = process.env.POCKETBASE_SUPERUSER_PASSWORD;
if (!email || !password) {
  throw new Error('Set POCKETBASE_SUPERUSER_EMAIL and POCKETBASE_SUPERUSER_PASSWORD.');
}

async function request(path, { method = 'GET', token, body } = {}) {
  const response = await fetch(`${baseUrl}${path}`, {
    method,
    headers: {
      ...(token ? { Authorization: `Bearer ${token}` } : {}),
      ...(body ? { 'Content-Type': 'application/json' } : {}),
    },
    ...(body ? { body: JSON.stringify(body) } : {}),
  });
  const raw = await response.text();
  const data = raw ? JSON.parse(raw) : {};
  if (!response.ok) throw new Error(`${method} ${path} returned ${response.status}: ${JSON.stringify(data)}`);
  return data;
}

const auth = await request('/api/collections/_superusers/auth-with-password', {
  method: 'POST', body: { identity: email, password },
});
const token = auth.token;
const slug = 'demo-novokuznetsk-walk';
const existing = await request(`/api/collections/routes/records?filter=${encodeURIComponent(`slug = "${slug}"`)}&perPage=1`, { token });
if (existing.items.length) {
  console.log(`Demo route already exists (${existing.items[0].id}).`);
  process.exit(0);
}

const route = await request('/api/collections/routes/records', {
  method: 'POST', token,
  body: {
    slug,
    title: 'ДЕМО · Прогулка по Новокузнецку',
    summary: 'Тестовый маршрут для проверки приложения. Названия точек и путь условные.',
    description: 'ДЕМО-ДАННЫЕ. Не является опубликованной городской экскурсией или рекомендацией маршрута.',
    distance_km: 0.8,
    estimated_minutes: 20,
    reward_points: 30,
    checkpoint_radius_m: 30,
    difficulty: 'easy',
    status: 'published',
  },
});
const points = [
  { title: 'Демо-точка 1', latitude: 53.7570, longitude: 87.1360 },
  { title: 'Демо-точка 2', latitude: 53.7576, longitude: 87.1360 },
  { title: 'Демо-финиш', latitude: 53.7582, longitude: 87.1360, is_finish: true },
];
  for (const [index, point] of points.entries()) {
  await request('/api/collections/route_checkpoints/records', {
    method: 'POST', token,
    body: {
      ...point,
      route: route.id,
      sequence: index + 1,
      description: 'Условная демо-точка для проверки GPS; не реальный объект.',
    },
  });
}
console.log(`Created clearly labeled demo route and ${points.length} checkpoints (${route.id}).`);
