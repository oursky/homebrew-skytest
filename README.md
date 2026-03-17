# homebrew-skytest

Homebrew tap for the `skytest` CLI.

## Clean Install (Recommended)

Use this when installing for the first time, or when your tap may have stale local state.

1. Remove any existing install and tap:

```bash
brew uninstall skytest || true
brew untap oursky/skytest || true
```

2. Add the official tap:

```bash
brew tap oursky/skytest
```

3. Install `skytest`:

```bash
brew install oursky/skytest/skytest
```

4. Verify the installed version:

```bash
skytest version
```

## Upgrade

1. Refresh Homebrew metadata:

```bash
brew update
```

2. Upgrade `skytest`:

```bash
brew upgrade oursky/skytest/skytest
```

3. Verify the upgraded version:

```bash
skytest version
```

## Uninstall

1. Uninstall `skytest`:

```bash
brew uninstall skytest
```

2. Optional: remove the tap if you no longer need it:

```bash
brew untap oursky/skytest
```

## Reset a Stale Tap

If `brew` still installs an old version, run:

```bash
brew untap oursky/skytest
brew tap oursky/skytest
brew update
brew reinstall oursky/skytest/skytest
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
