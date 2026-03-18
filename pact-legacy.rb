class PactLegacy < Formula
  desc "Standalone pact CLI executable using the Ruby Pact impl and Traveling Ruby"
  homepage "https://github.com/pact-foundation/pact-standalone"
  version "2.6.0"
  license "MIT"
  deprecate! date: "2027-01-01", because: :reason, replacement_formula: "pact-foundation/tap/pact"

  on_macos do
    on_intel do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.0/pact-2.6.0-osx-x86_64.tar.gz"
      sha256 "ead7e6e6772d58f64417172c1d30dc263a6cd1086f601d4132a22b25ce13ab41"
    end
    on_arm do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.0/pact-2.6.0-osx-arm64.tar.gz"
      sha256 "43030245ee921d605f5ff966b8d1a52895a9ddbad306cbdcaa7c0c56441e5569"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.0/pact-2.6.0-linux-x86_64.tar.gz"
      sha256 "748f9a6036460cc4fa952adc760e95e9d2935ae95b366d72592321130dd09e63"
    end
    on_arm do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.6.0/pact-2.6.0-linux-arm64.tar.gz"
      sha256 "5b6ed522d90d98fabc3a911712b4ec89d5787b0620a133e70e795cef5edab98e"
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
