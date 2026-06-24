class SkytestRunner < Formula
  desc "Runner management CLI for SkyTest"
  homepage "https://github.com/oursky/skytest-agent"
  version "0.2.0"
  license "MIT"

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.2.0/skytest-runner-0.2.0-darwin-arm64.tar.gz"
      sha256 "3a96e15feaad9bb47e13921e8d12ca6885bc77a69d9fc36626f9691e0b6e93de"
    end

    on_intel do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.2.0/skytest-runner-0.2.0-darwin-amd64.tar.gz"
      sha256 "11dd7842c85b1447854b92188460e7bebd033391b0bde305c8b2e2003f8d5276"
    end
  end

  def install
    libexec.install Dir["*"]
    ENV["PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD"] = "1"
    ENV["PRISMA_SKIP_POSTINSTALL_GENERATE"] = "1"
    system "npm", "ci", "--prefix", libexec

    state_dir = var/"skytest"
    state_dir.mkpath

    (bin/"skytest-runner").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      export SKYTEST_STATE_DIR="#{state_dir}"
      export SKYTEST_CLI_VERSION="#{version}"
      exec node --import "#{libexec}/node_modules/tsx/dist/loader.mjs" "#{libexec}/apps/cli/src/index.ts" "$@"
    EOS

    chmod 0755, bin/"skytest-runner"
  end

  test do
    output = shell_output("#{bin}/skytest-runner version")
    assert_match(version.to_s, output)
  end
end
