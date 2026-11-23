#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PB_VERSION="${POCKETBASE_VERSION:-0.40.6}"
PB_DIR="$ROOT_DIR/.tools/pocketbase"
PB_BIN="$PB_DIR/pocketbase"
DATA_DIR="$ROOT_DIR/.local/pocketbase-data"

if [[ ! -x "$PB_BIN" ]]; then
  os="$(uname -s | tr '[:upper:]' '[:lower:]')"
  arch="$(uname -m)"
  case "$arch" in
    arm64|aarch64) arch="arm64" ;;
    x86_64|amd64) arch="amd64" ;;
    *) echo "Unsupported PocketBase architecture: $arch" >&2; exit 1 ;;
  esac
  case "$os" in
    darwin) ;;
    linux) ;;
    *) echo "Unsupported PocketBase operating system: $os" >&2; exit 1 ;;
  esac

  archive="pocketbase_${PB_VERSION}_${os}_${arch}.zip"
  download_dir="$(mktemp -d)"
  trap 'rm -rf "$download_dir"' EXIT
  mkdir -p "$PB_DIR"
  curl --fail --location --silent --show-error \
    "https://github.com/pocketbase/pocketbase/releases/download/v${PB_VERSION}/${archive}" \
    --output "$download_dir/$archive"
  unzip -q "$download_dir/$archive" pocketbase -d "$download_dir"
  install -m 755 "$download_dir/pocketbase" "$PB_BIN"
fi

mkdir -p "$DATA_DIR"
cd "$ROOT_DIR"
"$PB_BIN" migrate up --dir="$DATA_DIR" --migrationsDir="$ROOT_DIR/pb_migrations" --hooksDir="$ROOT_DIR/pb_hooks"
exec "$PB_BIN" serve --http="${POCKETBASE_LISTEN:-127.0.0.1:8090}" --dir="$DATA_DIR" --migrationsDir="$ROOT_DIR/pb_migrations" --hooksDir="$ROOT_DIR/pb_hooks"
