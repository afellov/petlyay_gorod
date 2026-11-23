# Codex project instructions

## Architecture

- Keep the feature-first structure under `lib/features/<feature>/`; place shared app infrastructure, theme, navigation, and reusable widgets under `lib/core/`.
- Preserve the existing presentation/domain/data separation where a feature uses it. Keep PocketBase access in repositories and the shared client in `lib/core/network/pb_client.dart`.
- Follow the existing Flutter, Dart, and BLoC conventions. Avoid unrelated refactors and duplicated screen components.

## Figma and interface work

- Implement one explicitly requested screen or component at a time. Treat the supplied Figma Design frames and user screenshots as the visual source of truth for layout, sizing, color, typography, and imagery.
- Use Figma as a read-only design source. Do not edit the Figma file or create FigJam diagrams.
- Do not invent screens, controls, content, or behavior. For a layout-only task, do not add business logic. A control with unspecified behavior may remain visually faithful but non-interactive.
- Keep the bottom navigation as a floating pill-shaped island with no background panel outside the island. Keep the shop tab visually disabled.
- For visual changes, run the requested screen in iOS Simulator and compare a screenshot with the supplied reference when the simulator is available. Report any unavailable Figma or simulator access accurately.

## Product scope

- The shop, QR functionality, and EVRAZ assignment are not implemented; preserve their existing disabled or placeholder presentation until explicitly requested.
- The map is a basic OpenStreetMap view. Do not add route plotting or turn-by-turn navigation unless explicitly requested.
- GPS checkpoint visits are part of the route-completion design. Preserve sequential server-validated checkpoints, configurable geofence radius, accuracy checks, and server-controlled rewards. Never let the client set completion status or balance directly.
- Do not add 2FA unless it becomes an explicit agreed requirement.

## Quality and change boundaries

- Do not modify unrelated screens, PocketBase schema, or business behavior to satisfy a visual-only request.
- Keep local databases, credentials, build output, caches, logs, and simulator screenshots out of commits.
- Run `flutter analyze`, relevant tests, and `git diff --check` when requested or when they are needed to verify the change. Run integration tests only against a local development backend and report their side effects.
- Do not commit, push, merge branches, or create a Pull Request unless the user explicitly asks. Preserve unrelated user changes and wait for the user's next task instead of starting speculative work.
