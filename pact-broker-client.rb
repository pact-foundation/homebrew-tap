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
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.8/pact-broker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "01f3a908e0b5c5fd1dda5a062fdc023810f7a982f2101ef31d316f266b1d986e"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.8/pact-broker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "a571c9264e57262163b767d3f05f977d0457bc8fdeb99f07aec4b83c9f10aaf0"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.8/pact-broker-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "c12745595ab437ebd80bfa43d66da656536162e64a6409277a84d40ecd034e2c"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.8/pact-broker-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "d1da079f6c4583cc4af84dbea6406e5d0a3f0e3ae603b850c90592090e55d315"
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
