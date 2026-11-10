#!/usr/bin/env bash
# heal-auth.sh — repair the Spotify MCP auth when writes return 403 Forbidden.
#
# ROOT CAUSE this heals:
#   spotipy only re-runs OAuth consent when the *requested* scopes are NOT a
#   subset of the *cached* token's `scope` string. If the cache file ever ends
#   up advertising write scopes (playlist-modify-*) that the underlying grant
#   never actually included (e.g. a hand-edited cache, or a partial grant),
#   spotipy trusts the cache and silently refreshes a read-only token forever.
#   Spotify refresh NEVER adds scopes, so writes 403 permanently until the
#   cache is deleted and a fresh consent (show_dialog) is performed.
#
# WHAT THIS DOES:
#   1. Backs up and deletes the token cache so no stale grant can be reused.
#   2. Kills any running spotify-mcp process so the in-memory token is dropped.
#   AFTER running: trigger any Spotify MCP action. With no cache, the patched
#   server runs a fresh consent (show_dialog=True) — approve it once in the
#   browser and write scopes (playlist-modify-private/public) are granted.
set -euo pipefail

CACHE="$HOME/.spotify-mcp-token.json"

echo "== Spotify MCP auth heal =="

if [ -f "$CACHE" ]; then
  STAMP="$(python3 -c 'import time;print(int(time.time()))')"
  cp "$CACHE" "$CACHE.bak.$STAMP"
  rm -f "$CACHE"
  echo "✓ removed token cache (backup: $CACHE.bak.$STAMP)"
else
  echo "• no token cache present (already clean)"
fi

PIDS="$(pgrep -f 'spotify[_-]mcp' || true)"
if [ -n "$PIDS" ]; then
  # shellcheck disable=SC2086
  kill $PIDS 2>/dev/null || true
  sleep 1
  echo "✓ stopped running spotify-mcp process(es): $PIDS"
else
  echo "• no running spotify-mcp process"
fi

echo
echo "NEXT: In Claude Code run /mcp to reconnect 'spotify' (or restart Claude Code),"
echo "then ask for any Spotify action. A browser consent window will appear —"
echo "approve it once to grant the write scopes. Writes will then succeed."
