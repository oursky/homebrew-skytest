# homebrew-skytest

Homebrew tap for the `skytest-runner` CLI.

## Clean Install (Recommended)

Use this when installing for the first time, or when your tap may have stale local state.

1. Remove any existing install and tap:

```bash
brew uninstall skytest-runner || true
brew untap oursky/skytest || true
```

2. Add the official tap:

```bash
brew tap oursky/skytest
```

3. Install `skytest-runner`:

```bash
brew install oursky/skytest/skytest-runner
```

4. Verify the installed version:

```bash
skytest-runner version
```

## Upgrade

1. Refresh Homebrew metadata:

```bash
brew update
```

2. Upgrade `skytest-runner`:

```bash
brew upgrade oursky/skytest/skytest-runner
```

3. Verify the upgraded version:

```bash
skytest-runner version
```

## Uninstall

1. Uninstall `skytest-runner`:

```bash
brew uninstall skytest-runner
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
brew reinstall oursky/skytest/skytest-runner
skytest-runner version
```

## Repository Layout

- `Formula/skytest-runner.rb` - Homebrew formula published for users.
- `RELEASING.md` - maintainer release checklist.
- `.github/workflows/formula-ci.yml` - formula validation on PRs.
- `scripts/update-formula-from-release.sh` - manual formula sync helper.

## Source Of Truth

The formula is generated from `oursky/skytest-agent` release assets.

Primary path:
- `skytest-agent` release workflow auto-commits `Formula/skytest-runner.rb` into this tap.

Fallback path:
- maintainers can run `scripts/update-formula-from-release.sh vX.Y.Z`.
