class Skytest < Formula
  desc "SkyTest runner management CLI"
  homepage "https://github.com/oursky/skytest-agent"
  version "0.1.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.1/skytest-0.1.1-darwin-arm64.tar.gz"
      sha256 "a80a0f9d11c0356894dc72e2d9464dc87b1e914703bcc2b62345ce16a430789a"
    end

    on_intel do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.1/skytest-0.1.1-darwin-amd64.tar.gz"
      sha256 "6a851ecee85ef0832c095c0576e5bac6f15aa173f78f348e7e8ef2f4498a5f70"
    end
  end

  depends_on "node"

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
