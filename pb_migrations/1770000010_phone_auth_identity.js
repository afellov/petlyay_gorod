migrate((app) => {
  const users = app.findCollectionByNameOrId('users');
  users.fields.getByName('email').required = false;
  users.createRule = [
    '@request.body.points_balance:isset = false',
    '@request.body.experience:isset = false',
    '@request.body.tasks_completed:isset = false',
    '@request.body.kilometers_walked:isset = false',
    '@request.body.role:isset = false',
    '((@request.body.email:isset = true && @request.body.email != "") || (@request.body.phone:isset = true && @request.body.phone != ""))',
  ].join(' && ');
  users.passwordAuth = { enabled: true, identityFields: ['email', 'phone'] };
  app.save(users);
}, (app) => {
  const users = app.findCollectionByNameOrId('users');
  users.fields.getByName('email').required = true;
  users.createRule = [
    '@request.body.points_balance:isset = false',
    '@request.body.experience:isset = false',
    '@request.body.tasks_completed:isset = false',
    '@request.body.kilometers_walked:isset = false',
    '@request.body.role:isset = false',
    '@request.body.email:isset = true',
    '@request.body.email != ""',
  ].join(' && ');
  users.passwordAuth = { enabled: true, identityFields: ['email'] };
  app.save(users);
});
