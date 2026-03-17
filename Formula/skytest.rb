class Skytest < Formula
  desc "Runner management CLI for SkyTest"
  homepage "https://github.com/oursky/skytest-agent"
  version "0.1.3"
  license "MIT"

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.3/skytest-0.1.3-darwin-arm64.tar.gz"
      sha256 "f9a682310f78432eb170a022f777eae6debab7665f3050977ff596d6ed1583de"
    end

    on_intel do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.3/skytest-0.1.3-darwin-amd64.tar.gz"
      sha256 "5b6090bc053dfb8cbacae5e5d80fb1d0442df611ef9a9ae0563020e3191dfe7c"
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
