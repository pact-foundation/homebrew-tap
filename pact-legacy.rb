class PactLegacy < Formula
  desc "Standalone pact CLI executable using the Ruby Pact impl and Traveling Ruby"
  homepage "https://github.com/pact-foundation/pact-standalone"
  version "2.6.4"
  license "MIT"
  deprecate! date: "2027-01-01", because: :reason, replacement_formula: "pact-foundation/tap/pact"

  on_macos do
    on_intel do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.4/pact-2.6.4-macos-x86_64.tar.gz"
      sha256 "fe23549d3457037dace47727b4c6c4504dc726d342c8440571a24b0291949d42"
    end
    on_arm do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.4/pact-2.6.4-macos-arm64.tar.gz"
      sha256 "2d85da2bdfd3cca99fb98184e14b10fda8cf27bc12d124648d6502444e2fbc61"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.4/pact-2.6.4-linux-x86_64.tar.gz"
      sha256 "c0d77f4ad390ed8f56a1b46e9f56d4d656b0128202e95ea067a6dacc00b7cbbf"
    end
    on_arm do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.4/pact-2.6.4-linux-arm64.tar.gz"
      sha256 "8b7541ef6a5d1742436144b945cf6f26ad5a6f82d9ab5a6ec5dfac548187b33d"
    end
  end

  def install
    bin.install Dir["bin/*"].reject { |f|
      f.end_with?("/pact", "/pact-stub-server", "/pact_mock_server_cli", "/pact-plugin-cli", "/pact_verifier_cli")
    }.to_a
    lib.install Dir["lib/*"]
  end

  test do
    system "#{bin}/pact-broker", "help"
    system "#{bin}/pact-message", "help"
    system "#{bin}/pact-mock-service", "help"
    system "#{bin}/pact-provider-verifier", "help"
    system "#{bin}/pact-stub-service", "help"
    system "#{bin}/pactflow", "help"
  end
end
