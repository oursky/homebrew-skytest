# homebrew-skytest

Homebrew tap for the `skytest` CLI.

## Install

```bash
brew tap oursky/skytest
brew install skytest
skytest version
```

## Repository Layout

- `Formula/skytest.rb` - Homebrew formula published for users.
- `RELEASING.md` - maintainer release checklist.
- `.github/workflows/formula-ci.yml` - formula validation on PRs.
- `scripts/update-formula-from-release.sh` - manual formula sync helper.

## Source Of Truth

The formula is generated from `oursky/skytest-agent` release assets.

Primary path:
- `skytest-agent` release workflow auto-commits `Formula/skytest.rb` into this tap.

Fallback path:
- maintainers can run `scripts/update-formula-from-release.sh vX.Y.Z`.
