class Skytest < Formula
  desc "Runner management CLI for SkyTest"
  homepage "https://github.com/oursky/skytest-agent"
  version "0.1.2"
  license "MIT"

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.2/skytest-0.1.2-darwin-arm64.tar.gz"
      sha256 "15c370d0cf63c2b98ef17265981cdb01860095cbbca6c561e492b31e973baa77"
    end

    on_intel do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.2/skytest-0.1.2-darwin-amd64.tar.gz"
      sha256 "452043060e3be236887e6585ace6dfc8ed9d47be1105c789defc84e5e1323eda"
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
