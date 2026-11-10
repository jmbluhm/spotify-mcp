# spotify-mcp 🎧 — maintained fork

Connect **Claude** (Claude Code, Claude Desktop, Cursor, or any MCP client) to **Spotify**.
Ask for a playlist in plain language and it builds it in your account — search, playback,
queue, and full playlist create/edit.

> ### Why this fork?
> The excellent [original by **@varunneal**](https://github.com/varunneal/spotify-mcp) is no
> longer maintained, and in **February 2026 Spotify changed its Web API** in ways that broke
> every write: creating a playlist or adding songs started returning `403 Forbidden`. This
> fork **fixes that** (plus a login/token-persistence bug) so playlists work again — and it's
> **actively maintained with issues and PRs welcome**. All credit for the original project
> goes to Varun; this just keeps it running.

---

## Features

- 🎵 Create, edit, and manage playlists (the part the Feb-2026 API broke — fixed here)
- 🔍 Search tracks, albums, artists, and playlists
- ▶️ Start / pause / skip playback and manage the queue
- ℹ️ Get details about any track / album / artist / playlist

---

## Quick start

### 1. Create a Spotify developer app
1. Go to the [Spotify dashboard](https://developer.spotify.com/dashboard) and **Create app**.
2. Set the **Redirect URI** to exactly `http://127.0.0.1:8080/callback`
   (must be `http`, loopback IP `127.0.0.1`, not `localhost`).
3. Check **Web API** under the APIs/SDKs question, save, then copy your **Client ID** and **Client secret** from Settings.

> A **Spotify Premium** account is required for the developer API to create/modify playlists.

### 2. Add the server to your MCP client
Add this under `"mcpServers"` (e.g. `~/.claude.json` for Claude Code, or your Claude
Desktop / Cursor config):

```json
{
  "mcpServers": {
    "spotify": {
      "command": "uvx",
      "args": [
        "--python", "3.12",
        "--from", "git+https://github.com/jmbluhm/spotify-mcp",
        "--with", "pydantic<2.10",
        "spotify-mcp"
      ],
      "env": {
        "SPOTIFY_CLIENT_ID": "your_client_id",
        "SPOTIFY_CLIENT_SECRET": "your_client_secret",
        "SPOTIFY_REDIRECT_URI": "http://127.0.0.1:8080/callback"
      }
    }
  }
}
```

Requires [`uv`](https://docs.astral.sh/uv/) (`brew install uv` or the install script).

### 3. Connect & authorize (one time)
Restart your client (or `/mcp` reconnect in Claude Code), then ask *"what are my Spotify
playlists?"*. A browser window opens — click **Agree**. Your login is saved to
`~/.spotify-mcp-token.json` and persists across restarts.

Now try: **"Create a private playlist called Long Run with 15 upbeat ~170 BPM songs."**

---

## What's different from upstream

This fork is a drop-in replacement. Changes:

- **Spotify February 2026 Web API migration** — the breaking change that made the original
  return `403` on all writes:
  - `POST /users/{id}/playlists` (removed) → `POST /me/playlists`
  - playlist items: `/tracks` → `/items`, and the item payload key `track` → `item`
  - reads now use `GET /playlists/{id}/items`
- **Persistent OAuth token** — saves to `~/.spotify-mcp-token.json` with `show_dialog`, so
  write scopes actually grant and survive restarts (the original could silently re-mint a
  read-only, non-persistent token).
- **Honest errors** — add/remove operations now raise on failure instead of silently
  swallowing them.
- **`heal-auth.sh`** — one-shot helper to clear local token state if auth ever gets stuck.

---

## Troubleshooting

| Symptom | Fix |
|---|---|
| `403` creating/adding to playlists | Make sure your config points at **this** fork (`git+https://github.com/jmbluhm/spotify-mcp`), not the upstream — the upstream predates the Feb-2026 API change. |
| Reads work, writes loop / do nothing | Run `heal-auth.sh` to clear the saved token, then reconnect and approve the browser prompt again. |
| "Premium required" | The Spotify developer API needs a Premium account. |
| "Invalid redirect URI" | It must be exactly `http://127.0.0.1:8080/callback` in both the dashboard and your config. |
| Consent window never appears | Restart your MCP client once or twice; `uvx`'s first run sometimes needs it. |

Logs go to stderr. For Claude Desktop on macOS: `~/Library/Logs/Claude`.

---

## Contributing

Issues and PRs are **welcome** — that's the point of keeping this alive. If Spotify changes
the API again, or you hit a bug, open an issue with what you ran and the error. Small,
focused PRs are easiest to review.

---

## Credits & license

Original project by **[Varun Neal Srivastava](https://github.com/varunneal/spotify-mcp)**,
built on [spotipy](https://github.com/spotipy-dev/spotipy). This fork is maintained by
[@jmbluhm](https://github.com/jmbluhm) and keeps the original **MIT License** (see
[`LICENSE`](LICENSE)). Thanks to Varun and all the original contributors.
