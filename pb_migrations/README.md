# PocketBase migrations

The JavaScript migration extends PocketBase's built-in `users` auth collection and creates `routes`, `route_checkpoints`, `route_completions`, `route_checkpoint_visits`, and `point_transactions`. `scripts/setup-pocketbase.sh` runs `migrate up` with explicit migration and hooks directories before starting the server.

The migration creates schema only. It does not seed demo users/routes or award points. A client may start its own `in_progress` record, but checkpoint visits, completion, and point transactions are server-only. The authenticated hooks validate ordered visits, GPS accuracy and route radius, then finish and award within one database transaction.
