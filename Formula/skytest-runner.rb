class SkytestRunner < Formula
  desc "Runner management CLI for SkyTest"
  homepage "https://github.com/oursky/skytest-agent"
  version "0.2.2"
  license "MIT"

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.2.2/skytest-runner-0.2.2-darwin-arm64.tar.gz"
      sha256 "368e9e351f19acd495b2e7922ce5b80a4a7d9c83f45a023c7e7feae768c62631"
    end

    on_intel do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.2.2/skytest-runner-0.2.2-darwin-amd64.tar.gz"
      sha256 "e8f76aa820ba7ea3dd5787a31a7578d4bc6e16e82682687fa493cece3012fcfc"
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
