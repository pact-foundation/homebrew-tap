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
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.9.2/pact-broker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "15a8089fc5019b13e26bcb08c2b8bb1064b1168fb1cea82684ae3afc69e5f737"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.9.2/pact-broker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8ce59f74e745e0baf56d88f913a8bae6198872f5e9f68a70c010c2bccd336686"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.9.2/pact-broker-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "4f36dd5c0a84181d7db504f3720b77059d2099fee55828b1b008d8fb1a869471"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.9.2/pact-broker-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "cca1dc3cd36df5ae57c7f51986ac2a53669f7eee8509c0f850ee723dd4453cb7"
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
