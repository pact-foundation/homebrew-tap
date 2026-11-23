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
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v1.0.0/pact-broker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "62ba5720e4988656340a74f56b003ed0166e15d10efdf16f4cc538bc7e0ede0c"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v1.0.0/pact-broker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "42d0f40920dc8b89b57fb42a41323b0e045f32a67f009d9636355efc9e96303d"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v1.0.0/pact-broker-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "976f84bc1dd74c193691e607bc57bbdd20ec3720ef660c8b3533ddd86c394fb5"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v1.0.0/pact-broker-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f40461ccfcbc21d95a079503fd1b817ad7d86cb55b80e28de90138f3377f41f8"
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
