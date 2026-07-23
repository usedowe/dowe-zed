#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$repo_root"
cargo check --target wasm32-wasip2

old_repo_root="/Users/varb/Work/do""we/"
old_extension_path="do""we/zed"
old_generated_path=".do""we/zed"
old_language_server_path="target/debug/do""we-language-server"

if rg -n \
  -e "$old_repo_root" \
  -e "$old_extension_path" \
  -e "$old_generated_path" \
  -e "$old_language_server_path" \
  --glob '!target/**' \
  --glob '!.zed-dev/**' \
  --glob '!Cargo.lock' \
  --glob '!extension.toml' \
  --glob '!README.md' \
  .; then
  exit 1
fi
