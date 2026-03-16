# Releasing `skytest` To Homebrew Tap

This tap is updated from `oursky/skytest-agent` release artifacts.

## One-Time Setup (GitHub UI)

1. In `oursky/skytest-agent`:
   - `Settings` -> `Secrets and variables` -> `Actions` -> add repository secret:
     - Name: `HOMEBREW_TAP_PAT`
     - Value: fine-grained PAT with `Contents: Read and write` on `oursky/homebrew-skytest`.
   - `Settings` -> `Secrets and variables` -> `Actions` -> add repository variable:
     - Name: `HOMEBREW_TAP_REPO`
     - Value: `oursky/homebrew-skytest`

2. Ensure release workflow exists in `skytest-agent`:
   - `.github/workflows/release-cli.yml`

## Normal Release Flow

1. In `oursky/skytest-agent`, release a SemVer tag (`vX.Y.Z`) via tag push or the workflow dispatch UI.
2. Wait for `Release CLI` workflow success.
3. Confirm GitHub release contains:
   - `skytest-<version>-darwin-arm64.tar.gz`
   - `skytest-<version>-darwin-amd64.tar.gz`
   - `checksums.txt`
   - `skytest.rb`
4. Confirm this tap repo gets an automated commit updating `Formula/skytest.rb`.

## Manual Fallback (if auto-update failed)

1. Run:

```bash
scripts/update-formula-from-release.sh vX.Y.Z
```

2. Review formula diff.
3. Commit and push to tap repo.

## Post-Release Verification

On macOS:

```bash
brew tap oursky/skytest
brew update
brew reinstall skytest
skytest version
```

The output version should match `X.Y.Z`.
