class PactLegacy < Formula
  desc "Standalone pact CLI executable using the Ruby Pact impl and Traveling Ruby"
  homepage "https://github.com/pact-foundation/pact-standalone"
  version "2.6.3"
  license "MIT"
  deprecate! date: "2027-01-01", because: :reason, replacement_formula: "pact-foundation/tap/pact"

  on_macos do
    on_intel do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.3/pact-2.6.3-macos-x86_64.tar.gz"
      sha256 "505a98e5a48ea3f273bcc1b0e8b48acbe16e3740fa8f4a57915ce53b4dd603d1"
    end
    on_arm do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.3/pact-2.6.3-macos-arm64.tar.gz"
      sha256 "3051d29607b9ddeceb816d848c25d4eb210e7e681d2a2951ce2e3df72d13deae"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.3/pact-2.6.3-linux-x86_64.tar.gz"
      sha256 "02e4489bc946a80ebe53633f692f6d75b14b58d9e9030b0008697c91b0ce0154"
    end
    on_arm do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.3/pact-2.6.3-linux-arm64.tar.gz"
      sha256 "d16a623406204476f36ca210a9e90f8f688ace173ce22c8da82f88a08c5f943f"
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
