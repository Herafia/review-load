#!/usr/bin/env bash
# Installe (ou met à jour) review-load dans ~/.local/bin
#   gh api repos/Herafia/review-load/contents/install.sh -H 'Accept: application/vnd.github.raw' | bash
set -euo pipefail

REPO="${REVIEW_LOAD_REPO:-Herafia/review-load}"
REF="${REVIEW_LOAD_REF:-main}"
SHARE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/review-load"
BIN_DIR="$HOME/.local/bin"

for cmd in gh jq; do
    command -v "$cmd" >/dev/null || { echo "❌ '$cmd' est requis. Installe-le puis relance." >&2; exit 1; }
done
gh auth status >/dev/null 2>&1 || { echo "❌ gh n'est pas authentifié : lance 'gh auth login'." >&2; exit 1; }

mkdir -p "$SHARE_DIR" "$BIN_DIR"
fetch() {
    gh api "repos/$REPO/contents/$1?ref=$REF" -H 'Accept: application/vnd.github.raw' > "$SHARE_DIR/$1.tmp"
    mv "$SHARE_DIR/$1.tmp" "$SHARE_DIR/$1"
}
fetch review-load
fetch team.txt
chmod +x "$SHARE_DIR/review-load"
ln -sf "$SHARE_DIR/review-load" "$BIN_DIR/review-load"

echo "✅ review-load installé dans $BIN_DIR/review-load"
case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *) echo "⚠️  $BIN_DIR n'est pas dans ton PATH. Ajoute à ton ~/.bashrc ou ~/.zshrc :"
       echo "    export PATH=\"\$HOME/.local/bin:\$PATH\"" ;;
esac
echo "👉 Essaie : review-load -o glpi-project -d"
