# hello-ecosystem

The pipeline pilot of the [sebastiancardona.dev](https://sebastiancardona.dev) ecosystem — a
deliberately tiny static site whose only job is to prove the deployment backbone end-to-end
before any real app uses it. Live at **<https://hello.sebastiancardona.dev>**.

## Why this exists

The tag→deploy pipeline ([`workflows`](https://github.com/sebastiancardona-dev/workflows)) was
designed app-agnostic and proven on this zero-risk app first: build → GHCR → GitHub Release →
SSH deploy → health-check gate → **auto-rollback** (demonstrated with a deliberately broken
release). Every later app in the ecosystem inherits deployment by copying two ~15-line
workflow files.

## Ecosystem contract

| Endpoint | Purpose |
|----------|---------|
| `/health` | gates every deploy; failing it triggers rollback |
| `/info` | `{version, git_sha, build_time}` stamped at image build — consumed by the ops Portal |

Runtime: `nginxinc/nginx-unprivileged` (non-root, port 8080), multi-stage build, pinned base.

## Release & test env

- **Production**: `git tag v0.1.1 && git push --tags` → live at hello.sebastiancardona.dev.
- **Testing env**: Actions → *test-env* → Run workflow on any branch → deployed to
  `hello.test.sebastiancardona.dev` (basic-auth-protected, throwaway).
