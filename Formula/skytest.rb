class Skytest < Formula
  desc "Runner management CLI for SkyTest"
  homepage "https://github.com/oursky/skytest-agent"
  version "0.1.9"
  license "MIT"

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.9/skytest-0.1.9-darwin-arm64.tar.gz"
      sha256 "469a997bebc9c5e65e0a5a8c123523fa4d2c5baf33eab4e656e76492281a6be8"
    end

    on_intel do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.9/skytest-0.1.9-darwin-amd64.tar.gz"
      sha256 "cab1d730564aa0fd10cc37ec5fb6047e826724664f4aae0f23a2a17f6b5bcfed"
    end
  end

  def install
    libexec.install Dir["*"]
    ENV["PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD"] = "1"
    ENV["PRISMA_SKIP_POSTINSTALL_GENERATE"] = "1"
    system "npm", "ci", "--prefix", libexec

    state_dir = var/"skytest"
    state_dir.mkpath

    (bin/"skytest").write <<~EOS
      #!/usr/bin/env bash
      set -euo pipefail
      export SKYTEST_STATE_DIR="#{state_dir}"
      export SKYTEST_CLI_VERSION="#{version}"
      exec node --import "#{libexec}/node_modules/tsx/dist/loader.mjs" "#{libexec}/apps/cli/src/index.ts" "$@"
    EOS

    chmod 0755, bin/"skytest"
  end

  test do
    output = shell_output("#{bin}/skytest version")
    assert_match(version.to_s, output)
  end
end
