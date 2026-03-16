class Skytest < Formula
  desc "Runner management CLI for SkyTest"
  homepage "https://github.com/oursky/skytest-agent"
  version "0.1.0"
  license "MIT"

  depends_on "node"

  on_macos do
    on_arm do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.0/skytest-0.1.0-darwin-arm64.tar.gz"
      sha256 "e2d49ca06ec3d6d3e5af57b6cce599ce227c07e47af7ecddfee11130ccd852b8"
    end

    on_intel do
      url "https://github.com/oursky/skytest-agent/releases/download/v0.1.0/skytest-0.1.0-darwin-amd64.tar.gz"
      sha256 "54cdb2f7732fa63d6801c69554d7cc65d360f5bb5256b279d0b29caa1687c7ab"
    end
  end

  def install
    libexec.install Dir["*"]
    system "npm", "install", *std_npm_args(prefix: libexec), "tsx@4.20.6"

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
