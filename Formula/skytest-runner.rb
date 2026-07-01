class SkytestRunner < Formula
  desc "Runner management CLI for SkyTest"
  homepage "https://github.com/oursky/skytest-agent"
  version "0.2.1"
  license "MIT"

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.2.1/skytest-runner-0.2.1-darwin-arm64.tar.gz"
      sha256 "c9f3f2ec48982f6a7fb4c9c4b1d7f786e7b9ef6315a2a37343db5c8b0a5a898e"
    end

    on_intel do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.2.1/skytest-runner-0.2.1-darwin-amd64.tar.gz"
      sha256 "b5ce3808f40cdfa2b275ad2bd351884f8d294b87301b617a83ca2fd981bea198"
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
