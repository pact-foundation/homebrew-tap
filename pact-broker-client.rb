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
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.4/pact-broker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "16a26b18617f223ff8a634f27f72a96b5bfbb32b4795bc6fbb9893c1a1be7211"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.4/pact-broker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "42053e484a07eb449efa750a9d3d04c3ab1de1fad20c2f42c1636f32c1b46746"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.4/pact-broker-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "1c65f15cc85acb43ab15b5a1d540d7e556228fdbb053f76d032ed6278b7502a2"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.4/pact-broker-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "450a48c41cd61e3334ff4e82eddd89da87b7387801be13a8b194a9eb0793e8b7"
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
