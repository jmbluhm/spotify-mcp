# Contributing

Thanks for your interest! This is a small, friendly fork whose main job is to **keep
spotify-mcp working** as Spotify changes its API. You don't need to be an expert to help —
bug reports and doc fixes are just as valuable as code.

## Ways to help

- **Report a bug** — something broke or returns an error.
- **Request a feature** — a Spotify capability you'd like exposed.
- **Improve docs** — a confusing step, a typo, a missing detail.
- **Send code** — a fix or a small feature.

All of these happen through GitHub **Issues** (to discuss) and **Pull Requests** (to propose
changes). If you're new to that, no worries — the steps are below.

## Reporting a bug (open an Issue)

Go to the [Issues tab](https://github.com/jmbluhm/spotify-mcp/issues) → **New issue**, and
include:

1. **What you did** — the prompt or tool call you ran.
2. **What happened** — the exact error text (and any logs; on macOS Claude Desktop writes
   them to `~/Library/Logs/Claude`).
3. **What you expected** instead.
4. **Your setup** — OS, MCP client (Claude Code / Desktop / Cursor), and whether you're on
   Spotify Premium.

The more specific, the faster it can be fixed. A `403` on a write usually means Spotify
changed an endpoint again — that detail alone is a big help.

## Suggesting a change (open a Pull Request)

If you'd like to change the code, here's the normal GitHub flow:

1. **Fork** this repo (button, top-right) — that makes your own copy.
2. **Create a branch** for your change:
   ```bash
   git checkout -b fix-playlist-reorder
   ```
3. Make your edit, then **commit** with a short message saying *what* and *why*:
   ```bash
   git commit -am "Fix: reorder endpoint used removed /tracks path"
   ```
4. **Push** your branch and open a **Pull Request** against `main` here. GitHub will prompt
   you after you push.
5. In the PR description, say what it does and how you tested it.

Small, focused PRs are much easier to review and merge than large ones. If you're planning
something big, open an issue first so we can talk it through before you spend the time.

## Developing locally

```bash
git clone https://github.com/jmbluhm/spotify-mcp
cd spotify-mcp
uv sync
```

Set `SPOTIFY_CLIENT_ID`, `SPOTIFY_CLIENT_SECRET`, and
`SPOTIFY_REDIRECT_URI=http://127.0.0.1:8080/callback` (from your own Spotify developer app),
then run the server through your MCP client pointed at this directory, or inspect it with:

```bash
npx @modelcontextprotocol/inspector uv --directory . run spotify-mcp
```

There's no automated test suite yet (adding one is very welcome!), so please **test your
change by hand** against a real Spotify account and mention what you tried in the PR.

## Style

Match the surrounding code — it's plain, readable Python. Keep changes minimal and focused;
avoid unrelated reformatting in the same PR so reviews stay easy.

## A note on tone

Be kind and assume good faith. This is a volunteer-maintained project; questions are
welcome, and "I'm new to this" is always a fine thing to say.

## License

By contributing, you agree your contributions are licensed under the project's
[MIT License](LICENSE).
