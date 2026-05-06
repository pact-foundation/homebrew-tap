class PactBrokerClient < Formula
  desc "Client for interacting with Pact Broker"
  homepage "https://github.com/pact-foundation/pact-broker-cli"
  url "https://github.com/pact-foundation/pact-broker-cli.git"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  head do
    url "https://github.com/pact-foundation/pact-broker-cli.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    on_intel do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.7.0/pact-broker-cli-x86_64-macos"
      sha256 "66703818df406cfae49abd82c686b356b41743061ab59c0dbb514604b44d6626"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.7.0/pact-broker-cli-aarch64-macos"
      sha256 "bdd49c7161268cff79233cc3759d9ec553b1268c4d77fd0d27609769e6b2727b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.7.0/pact-broker-cli-x86_64-linux-musl"
      sha256 "a3e023c9cf8a9f1b80a7c0da2ba6992799207ae6a4993f030f08746a52a75a0d"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.7.0/pact-broker-cli-aarch64-linux-musl"
      sha256 "c466ab69af1ccef553e81a94c59bb286343f8e5ecb0994085770144f53704758"
    end
  end

  def install
    if build.head?
      # Build from source if no precompiled binary is available
      system "cargo", "install", *std_cargo_args
    elsif OS.mac?
      if Hardware::CPU.intel?
        bin.install "pact-broker-cli-x86_64-macos" => "pact-broker-client"
      else
        bin.install "pact-broker-cli-aarch64-macos" => "pact-broker-client"
      end
    elsif OS.linux?
      if Hardware::CPU.intel?
        bin.install "pact-broker-cli-x86_64-linux-musl" => "pact-broker-client"
      else
        bin.install "pact-broker-cli-aarch64-linux-musl" => "pact-broker-client"
      end
    end
  end

  test do
    # Test that the binary is properly linked and executable
    assert_predicate bin/"pact-broker-client", :executable?

    # Test error handling - invalid command should fail gracefully
    shell_output("#{bin}/pact-broker-client invalid-command", 2)

    # Test the pact-broker-client command with an inaccessible broker
    args = [
      "list-latest-pact-versions",
      "--broker-base-url",
      "http://localhost:9292",
    ]
    output = shell_output("#{bin}/pact-broker-client #{args.join(" ")} 2>&1", 1)

    # Should fail gracefully when broker is not accessible
    assert_match(/Failed to access pact broker/, output)
  end
end
