class Skytest < Formula
  desc "Runner management CLI for SkyTest"
  homepage "https://github.com/oursky/skytest-agent"
  version "0.1.8"
  license "MIT"

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.8/skytest-0.1.8-darwin-arm64.tar.gz"
      sha256 "4844f612aafb930cb9752ad88ac3f0993e97e87c42603ed6ae2d6d120843f3e5"
    end

    on_intel do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.8/skytest-0.1.8-darwin-amd64.tar.gz"
      sha256 "78aac6ae58c54ce8ce2fa408f06381ee2685686809b7f0f0e54e3423a9b98ce8"
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
