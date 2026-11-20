migrate((app) => {
  const users = app.findCollectionByNameOrId('users');
  users.listRule = 'id = @request.auth.id';
  users.viewRule = 'id = @request.auth.id';
  users.createRule = [
    '@request.body.points_balance:isset = false',
    '@request.body.experience:isset = false',
    '@request.body.tasks_completed:isset = false',
    '@request.body.kilometers_walked:isset = false',
    '@request.body.role:isset = false',
    '((@request.body.email:isset = true && @request.body.email != "") || (@request.body.phone:isset = true && @request.body.phone != ""))',
  ].join(' && ');
  users.updateRule = [
    'id = @request.auth.id',
    '@request.body.points_balance:changed = false',
    '@request.body.experience:changed = false',
    '@request.body.tasks_completed:changed = false',
    '@request.body.kilometers_walked:changed = false',
    '@request.body.role:changed = false',
    '@request.body.verified:changed = false',
    '@request.body.email:changed = false',
  ].join(' && ');
  users.manageRule = null;
  users.fields.add(new TextField({ name: 'phone', max: 32 }));
  users.fields.add(new NumberField({ name: 'points_balance', onlyInt: true, min: 0 }));
  users.fields.add(new NumberField({ name: 'experience', onlyInt: true, min: 0 }));
  users.fields.add(new NumberField({ name: 'tasks_completed', onlyInt: true, min: 0 }));
  users.fields.add(new NumberField({ name: 'kilometers_walked', min: 0 }));
  users.fields.add(new SelectField({ name: 'role', maxSelect: 1, values: ['user', 'admin'] }));
  users.indexes.push('CREATE UNIQUE INDEX idx_users_phone ON users (phone) WHERE phone != ""');
  users.fields.getByName('email').required = false;
  users.passwordAuth = { enabled: true, identityFields: ['email', 'phone'] };
  users.otp = { enabled: false, duration: 180, length: 8 };
  users.mfa = { enabled: false, duration: 1800 };
  app.save(users);

  const routes = new Collection({
    type: 'base',
    name: 'routes',
    listRule: 'status = "published"',
    viewRule: 'status = "published"',
    createRule: null,
    updateRule: null,
    deleteRule: null,
    fields: [
      { type: 'text', name: 'slug', required: true, min: 1, max: 100 },
      { type: 'text', name: 'title', required: true, min: 1, max: 160 },
      { type: 'text', name: 'summary', max: 300 },
      { type: 'editor', name: 'description' },
      {
        type: 'file',
        name: 'cover',
        maxSelect: 1,
        maxSize: 10485760,
        mimeTypes: ['image/jpeg', 'image/png', 'image/webp'],
      },
      {
        type: 'file',
        name: 'gallery',
        maxSelect: 10,
        maxSize: 10485760,
        mimeTypes: ['image/jpeg', 'image/png', 'image/webp'],
      },
      { type: 'number', name: 'distance_km', min: 0 },
      { type: 'number', name: 'estimated_minutes', onlyInt: true, min: 0 },
      { type: 'number', name: 'reward_points', onlyInt: true, min: 0 },
      { type: 'number', name: 'checkpoint_radius_m', onlyInt: true, min: 5, max: 100, required: true },
      {
        type: 'select',
        name: 'difficulty',
        maxSelect: 1,
        values: ['easy', 'medium', 'hard'],
      },
      {
        type: 'select',
        name: 'status',
        required: true,
        maxSelect: 1,
        values: ['draft', 'published', 'archived'],
      },
    ],
    indexes: [
      'CREATE UNIQUE INDEX idx_routes_slug ON routes (slug)',
      'CREATE INDEX idx_routes_status_title ON routes (status, title)',
    ],
  });
  app.save(routes);

  const checkpoints = new Collection({
    type: 'base',
    name: 'route_checkpoints',
    listRule: 'route.status = "published"',
    viewRule: 'route.status = "published"',
    createRule: null,
    updateRule: null,
    deleteRule: null,
    fields: [
      { type: 'relation', name: 'route', collectionId: routes.id, maxSelect: 1, cascadeDelete: true, required: true },
      { type: 'number', name: 'sequence', onlyInt: true, min: 0, required: true },
      { type: 'text', name: 'title', required: true, max: 120 },
      { type: 'text', name: 'description', max: 300 },
      { type: 'number', name: 'latitude', required: true, min: -90, max: 90 },
      { type: 'number', name: 'longitude', required: true, min: -180, max: 180 },
      { type: 'bool', name: 'is_finish' },
    ],
    indexes: [
      'CREATE UNIQUE INDEX idx_route_checkpoints_route_sequence ON route_checkpoints (route, sequence)',
      'CREATE INDEX idx_route_checkpoints_route ON route_checkpoints (route, sequence)',
    ],
  });
  app.save(checkpoints);

  const completions = new Collection({
    type: 'base',
    name: 'route_completions',
    listRule: 'user = @request.auth.id',
    viewRule: 'user = @request.auth.id',
    createRule: [
      'user = @request.auth.id',
      'route.status = "published"',
      '@request.body.status = "in_progress"',
      '@request.body.completed_at:isset = false',
    ].join(' && '),
    updateRule: null,
    deleteRule: null,
    fields: [
      {
        type: 'relation',
        name: 'user',
        collectionId: users.id,
        maxSelect: 1,
        cascadeDelete: true,
        required: true,
      },
      {
        type: 'relation',
        name: 'route',
        collectionId: routes.id,
        maxSelect: 1,
        cascadeDelete: false,
        required: true,
      },
      {
        type: 'select',
        name: 'status',
        required: true,
        maxSelect: 1,
        values: ['in_progress', 'completed', 'cancelled'],
      },
      { type: 'date', name: 'completed_at' },
      { type: 'text', name: 'attempt_key', required: true, min: 16, max: 64 },
      { type: 'autodate', name: 'created', onCreate: true },
      { type: 'autodate', name: 'updated', onCreate: true, onUpdate: true },
    ],
    indexes: [
      'CREATE UNIQUE INDEX idx_route_completions_attempt_key ON route_completions (attempt_key)',
      'CREATE INDEX idx_route_completions_user_created ON route_completions (user, created)',
      'CREATE INDEX idx_route_completions_route_status ON route_completions (route, status)',
    ],
  });
  app.save(completions);

  const visits = new Collection({
    type: 'base',
    name: 'route_checkpoint_visits',
    listRule: 'completion.user = @request.auth.id',
    viewRule: 'completion.user = @request.auth.id',
    createRule: null,
    updateRule: null,
    deleteRule: null,
    fields: [
      { type: 'relation', name: 'completion', collectionId: completions.id, maxSelect: 1, cascadeDelete: true, required: true },
      { type: 'relation', name: 'checkpoint', collectionId: checkpoints.id, maxSelect: 1, cascadeDelete: false, required: true },
      { type: 'number', name: 'latitude', required: true, min: -90, max: 90 },
      { type: 'number', name: 'longitude', required: true, min: -180, max: 180 },
      { type: 'number', name: 'accuracy_m', required: true, min: 0 },
      { type: 'date', name: 'visited_at', required: true },
    ],
    indexes: [
      'CREATE UNIQUE INDEX idx_checkpoint_visit_once ON route_checkpoint_visits (completion, checkpoint)',
      'CREATE INDEX idx_checkpoint_visits_completion ON route_checkpoint_visits (completion, visited_at)',
    ],
  });
  app.save(visits);

  const transactions = new Collection({
    type: 'base',
    name: 'point_transactions',
    listRule: 'user = @request.auth.id',
    viewRule: 'user = @request.auth.id',
    createRule: null,
    updateRule: null,
    deleteRule: null,
    fields: [
      {
        type: 'relation',
        name: 'user',
        collectionId: users.id,
        maxSelect: 1,
        cascadeDelete: true,
        required: true,
      },
      {
        type: 'relation',
        name: 'completion',
        collectionId: completions.id,
        maxSelect: 1,
        cascadeDelete: false,
      },
      { type: 'number', name: 'amount', onlyInt: true, required: true },
      {
        type: 'select',
        name: 'kind',
        required: true,
        maxSelect: 1,
        values: ['route_reward', 'admin_adjustment'],
      },
      { type: 'text', name: 'description', max: 240 },
      { type: 'text', name: 'idempotency_key', required: true, min: 16, max: 64 },
      { type: 'autodate', name: 'created', onCreate: true },
    ],
    indexes: [
      'CREATE UNIQUE INDEX idx_point_transactions_idempotency ON point_transactions (idempotency_key)',
      'CREATE UNIQUE INDEX idx_point_transactions_completion ON point_transactions (completion) WHERE completion != ""',
      'CREATE INDEX idx_point_transactions_user_created ON point_transactions (user, created)',
    ],
  });
  app.save(transactions);
}, (app) => {
  const users = app.findCollectionByNameOrId('users');
  for (const name of ['phone', 'points_balance', 'experience', 'tasks_completed', 'kilometers_walked', 'role']) users.fields.removeByName(name);
  users.indexes = users.indexes.filter((index) => !index.includes('idx_users_phone'));
  users.listRule = null;
  users.viewRule = null;
  users.createRule = null;
  users.updateRule = null;
  users.passwordAuth = { enabled: true, identityFields: ['email'] };
  app.save(users);
  for (const name of [
    'point_transactions',
    'route_checkpoint_visits',
    'route_completions',
    'route_checkpoints',
    'routes',
  ]) {
    try {
      app.delete(app.findCollectionByNameOrId(name));
    } catch (_) {
      // A clean database may not contain every collection yet.
    }
  }
});
