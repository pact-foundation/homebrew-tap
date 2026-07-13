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
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.6/pact-broker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "02c3888f4ae5683f7d2bf99fc4838bc349216fe5fe925e03bd8fd7896ff6cbb9"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.6/pact-broker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f399dd9346ac693d987b9509b495e90365bdbdf7aacbc4ff09ebc34b894fbd2a"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.6/pact-broker-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "ffaa0cf297e36fbafa4bacc5c15e3ae65bab33c46b7af42f03d9466cbf6e165c"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.6/pact-broker-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "78a09ad68fa767b73a78e1a5986ce6f50c48f1698c5b988e2e8660e01b23f1d1"
    end
  end

  def install
    if build.head?
      # Build from source if no precompiled binary is available
      system "cargo", "install", *std_cargo_args
    else
      bin.install "pact-broker-cli" => "pact-broker-client"
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
