#!/usr/bin/env bash
# Installs (or updates) review-load in ~/.local/bin
#   gh api repos/Herafia/review-load/contents/install.sh -H 'Accept: application/vnd.github.raw' | bash
set -euo pipefail

REPO="${REVIEW_LOAD_REPO:-Herafia/review-load}"
REF="${REVIEW_LOAD_REF:-main}"
SHARE_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/review-load"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/review-load"
BIN_DIR="$HOME/.local/bin"

for cmd in gh jq; do
    command -v "$cmd" >/dev/null || { echo "❌ '$cmd' is required. Install it and run again." >&2; exit 1; }
done
gh auth status >/dev/null 2>&1 || { echo "❌ gh is not authenticated: run 'gh auth login'." >&2; exit 1; }

mkdir -p "$SHARE_DIR" "$BIN_DIR" "$CONFIG_DIR"
# Pin the installed commit: review-load uses it to know whether it is up to date
SHA=$(gh api "repos/$REPO/commits/$REF" --jq .sha)
fetch() {
    gh api "repos/$REPO/contents/$1?ref=$SHA" -H 'Accept: application/vnd.github.raw' > "$SHARE_DIR/$1.tmp"
    mv "$SHARE_DIR/$1.tmp" "$SHARE_DIR/$1"
}
fetch review-load
chmod +x "$SHARE_DIR/review-load"
printf 'REPO=%s\nREF=%s\nSHA=%s\n' "$REPO" "$REF" "$SHA" > "$SHARE_DIR/install.info"
ln -sf "$SHARE_DIR/review-load" "$BIN_DIR/review-load"

# Personal team list, never overwritten by an update
TEAM_FILE="$CONFIG_DIR/team.txt"
if [[ ! -f "$TEAM_FILE" ]]; then
    if [[ -f "$SHARE_DIR/team.txt" ]]; then
        # old install: keep the list that used to ship with the tool
        mv "$SHARE_DIR/team.txt" "$TEAM_FILE"
    else
        { echo "# GitHub logins of your team, one per line"; gh api user --jq .login; } > "$TEAM_FILE"
    fi
    NEW_TEAM=1
fi
rm -f "$SHARE_DIR/team.txt"

echo "✅ review-load installed in $BIN_DIR/review-load (version ${SHA:0:7})"
case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *) echo "⚠️  $BIN_DIR is not in your PATH. Add this to your ~/.bashrc or ~/.zshrc:"
       echo "    export PATH=\"\$HOME/.local/bin:\$PATH\"" ;;
esac
[[ -z "${NEW_TEAM:-}" ]] || echo "📝 Your team list: $TEAM_FILE (one GitHub login per line)"
echo "👉 Try this: review-load -m"
