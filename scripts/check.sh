#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$repo_root"
cargo check --target wasm32-wasip2

cd "$repo_root/tree-sitter-dowe"
tree-sitter test

for query in "$repo_root"/languages/dowe/*.scm; do
  tree-sitter query --quiet --grammar-path . "$query" test/corpus/server.txt >/dev/null
done

cd "$repo_root"

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
