#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 vX.Y.Z" >&2
  exit 1
fi

TAG="$1"
if [[ ! "${TAG}" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]; then
  echo "Tag must match vX.Y.Z or vX.Y.Z-suffix" >&2
  exit 1
fi

URL="https://github.com/oursky/skytest-agent/releases/download/${TAG}/skytest.rb"

echo "Downloading formula from ${URL}"
curl -fsSL "${URL}" -o "Formula/skytest.rb"
echo "Updated Formula/skytest.rb from ${TAG}"
