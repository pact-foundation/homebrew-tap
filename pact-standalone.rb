class PactStandalone < Formula
  desc "Standalone pact CLI executable using the Ruby Pact impl and Traveling Ruby"
  homepage "https://github.com/pact-foundation/pact-standalone"
  version "2.5.6"
  on_macos do
    on_intel do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.5.6/pact-2.5.6-osx-x86_64.tar.gz"
      sha256 "ae1ae90d3501574113b81554de93d38e3e7f9fe9544e64a9c3ec7e72cb38c8b7"
    end
    on_arm do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.5.6/pact-2.5.6-osx-arm64.tar.gz"
      sha256 "bd9eb34ef0eafa80741310be2efc1093aedb9ac85434c160e67bb06ed14a520a"
    end
  end
  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.5.6/pact-2.5.6-linux-x86_64.tar.gz"
      sha256 "a3e2708c782e50d74c84a3927b0c35800cc723c96a8739741494137b46579fac"
    end
    on_arm do
      url "https://github.com/pact-foundation/pact-standalone/releases/download/v2.5.6/pact-2.5.6-linux-arm64.tar.gz"
      sha256 "a811fb1e4855100729726ca93f15cd876502475cac7723f1517a0421bc4bb8fb"
    end
  end

  def install
    # pact-standalone
    bin.install Dir["bin/*"]
    lib.install Dir["lib/*"]
    puts "# Run 'pact-mock-service --help' (see https://github.com/pact-foundation/pact-standalone/releases/)"
  end

  test do
    system "#{bin}/pact", "help"
    system "#{bin}/pact-broker", "help"
    system "#{bin}/pact-message", "help"
    system "#{bin}/pact-plugin-cli", "help"
    system "#{bin}/pact-mock-service", "help"
    system "#{bin}/pact-provider-verifier", "help"
    system "#{bin}/pact-stub-service", "help"
    system "#{bin}/pactflow", "help"
  end
end
