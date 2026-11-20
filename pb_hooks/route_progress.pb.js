routerAdd("POST", "/api/gorod/route-progress/checkpoint", (e) => {
  const maxGpsAccuracyM = 25;
  const maxSpeedMps = 12;
  const defaultRadiusM = 30;
  const distanceMeters = (lat1, lon1, lat2, lon2) => {
    const rad = (value) => value * Math.PI / 180;
    const dLat = rad(lat2 - lat1);
    const dLon = rad(lon2 - lon1);
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(rad(lat1)) * Math.cos(rad(lat2)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    return 6371000 * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  };
  const body = e.requestInfo().body || {};
  const completionId = String(body.completion_id || "");
  const latitude = Number(body.latitude);
  const longitude = Number(body.longitude);
  const accuracy = Number(body.accuracy_m);
  if (!completionId || !isFinite(latitude) || !isFinite(longitude) ||
      !isFinite(accuracy) || latitude < -90 || latitude > 90 ||
      longitude < -180 || longitude > 180 || accuracy < 0 ||
      accuracy > maxGpsAccuracyM) {
    throw new BadRequestError("Недостаточная точность GPS или неверные координаты.");
  }

  let result = {};
  e.app.runInTransaction((txApp) => {
    const completion = txApp.findRecordById("route_completions", completionId);
    if (completion.get("user") !== e.auth.id) throw new ForbiddenError("Нет доступа к прохождению.");
    if (completion.get("status") !== "in_progress") throw new BadRequestError("Маршрут уже завершён или отменён.");

    const points = txApp.findRecordsByFilter("route_checkpoints", "route = {:route}", "sequence", 500, 0, { route: completion.get("route") });
    if (points.length === 0) throw new BadRequestError("У маршрута пока нет контрольных точек.");
    const visits = txApp.findRecordsByFilter("route_checkpoint_visits", "completion = {:completion}", "-visited_at", 500, 0, { completion: completionId });
    const visitedIds = {};
    visits.forEach((visit) => { visitedIds[visit.get("checkpoint")] = true; });
    const nextIndex = points.findIndex((point) => !visitedIds[point.id]);
    if (nextIndex < 0) throw new BadRequestError("Все контрольные точки уже пройдены.");

    if (visits.length > 0) {
      const previous = visits[0];
      const previousTime = Date.parse(previous.get("visited_at"));
      const elapsedSeconds = Math.max(1, (Date.now() - previousTime) / 1000);
      const moved = distanceMeters(previous.get("latitude"), previous.get("longitude"), latitude, longitude);
      if (moved / elapsedSeconds > maxSpeedMps) throw new BadRequestError("Перемещение выглядит невозможным. Подождите и повторите проверку.");
    }

    const point = points[nextIndex];
    const dist = distanceMeters(latitude, longitude, point.get("latitude"), point.get("longitude"));
    const route = txApp.findRecordById("routes", completion.get("route"));
    const radius = Number(route.get("checkpoint_radius_m")) || defaultRadiusM;
    if (dist > radius) throw new BadRequestError("Вы ещё не рядом со следующей контрольной точкой.");

    const visit = new Record(txApp.findCollectionByNameOrId("route_checkpoint_visits"));
    visit.set("completion", completionId);
    visit.set("checkpoint", point.id);
    visit.set("latitude", latitude);
    visit.set("longitude", longitude);
    visit.set("accuracy_m", accuracy);
    visit.set("visited_at", new Date().toISOString());
    txApp.save(visit);
    result = { checkpoint_id: point.id, title: point.get("title"), sequence: point.get("sequence"), is_finish: point.getBool("is_finish"), visited_count: visits.length + 1, total_count: points.length };
  });
  return e.json(200, result);
}, $apis.requireAuth("users"));

routerAdd("POST", "/api/gorod/route-progress/finish", (e) => {
  const maxGpsAccuracyM = 25;
  const maxSpeedMps = 12;
  const defaultRadiusM = 30;
  const distanceMeters = (lat1, lon1, lat2, lon2) => {
    const rad = (value) => value * Math.PI / 180;
    const dLat = rad(lat2 - lat1);
    const dLon = rad(lon2 - lon1);
    const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(rad(lat1)) * Math.cos(rad(lat2)) *
      Math.sin(dLon / 2) * Math.sin(dLon / 2);
    return 6371000 * 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  };
  const body = e.requestInfo().body || {};
  const completionId = String(body.completion_id || "");
  const latitude = Number(body.latitude);
  const longitude = Number(body.longitude);
  const accuracy = Number(body.accuracy_m);
  if (!completionId || !isFinite(latitude) || !isFinite(longitude) || !isFinite(accuracy) || latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180 || accuracy < 0 || accuracy > maxGpsAccuracyM) throw new BadRequestError("Не указан маршрут или недостаточная точность GPS.");
  let result = {};
  e.app.runInTransaction((txApp) => {
    const completion = txApp.findRecordById("route_completions", completionId);
    if (completion.get("user") !== e.auth.id) throw new ForbiddenError("Нет доступа к прохождению.");
    if (completion.get("status") === "completed") {
      result = { completed: true, repeated: true };
      return;
    }
    if (completion.get("status") !== "in_progress") throw new BadRequestError("Прохождение недоступно.");
    const points = txApp.findRecordsByFilter("route_checkpoints", "route = {:route}", "sequence", 500, 0, { route: completion.get("route") });
    const visits = txApp.findRecordsByFilter("route_checkpoint_visits", "completion = {:completion}", "-visited_at", 500, 0, { completion: completionId });
    if (points.length === 0 || visits.length !== points.length || !points[points.length - 1].getBool("is_finish")) {
      throw new BadRequestError("Сначала пройдите все контрольные точки, включая финиш.");
    }
    const visitedByCheckpoint = {};
    visits.forEach((visit) => { visitedByCheckpoint[visit.get("checkpoint")] = true; });
    if (points.some((point) => !visitedByCheckpoint[point.id])) throw new BadRequestError("Контрольные точки должны быть пройдены по порядку.");
    const lastVisit = visits[0];
    const finish = points[points.length - 1];
    if (lastVisit.get("checkpoint") !== finish.id) throw new BadRequestError("Не подтверждена финишная точка.");
    const finishDistance = distanceMeters(latitude, longitude, finish.get("latitude"), finish.get("longitude"));
    const radius = Number(txApp.findRecordById("routes", completion.get("route")).get("checkpoint_radius_m")) || defaultRadiusM;
    if (finishDistance > radius) throw new BadRequestError("Для завершения необходимо находиться рядом с финишем.");
    const lastVisitTime = Date.parse(lastVisit.get("visited_at"));
    const elapsedSeconds = Math.max(1, (Date.now() - lastVisitTime) / 1000);
    const moved = distanceMeters(lastVisit.get("latitude"), lastVisit.get("longitude"), latitude, longitude);
    if (moved / elapsedSeconds > maxSpeedMps) throw new BadRequestError("Перемещение выглядит невозможным. Подождите и повторите проверку.");
    const route = txApp.findRecordById("routes", completion.get("route"));
    const user = txApp.findRecordById("users", completion.get("user"));
    const reward = Math.max(0, Number(route.get("reward_points")) || 0);
    const transaction = new Record(txApp.findCollectionByNameOrId("point_transactions"));
    transaction.set("user", user.id);
    transaction.set("completion", completion.id);
    transaction.set("amount", reward);
    transaction.set("kind", "route_reward");
    transaction.set("description", "Награда за прохождение: " + route.get("title"));
    transaction.set("idempotency_key", "route-completion-" + completion.id);
    txApp.save(transaction);
    user.set("points_balance", (Number(user.get("points_balance")) || 0) + reward);
    user.set("experience", (Number(user.get("experience")) || 0) + reward);
    user.set("tasks_completed", (Number(user.get("tasks_completed")) || 0) + 1);
    user.set("kilometers_walked", (Number(user.get("kilometers_walked")) || 0) + (Number(route.get("distance_km")) || 0));
    txApp.save(user);
    completion.set("status", "completed");
    completion.set("completed_at", new Date().toISOString());
    txApp.save(completion);
    result = { completed: true, awarded_points: reward };
  });
  return e.json(200, result);
}, $apis.requireAuth("users"));
