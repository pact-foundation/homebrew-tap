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
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.5/pact-broker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "8bd21c1bfa212716be909fafbfa753aa96422122525d411a4ed42f8dcba343ce"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.5/pact-broker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "db60b3910bebe1c4238f609089d2d98a6da1ab39dab67fa0ef767f494a279fd8"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.5/pact-broker-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "d0c1efa50f610ee1722d15b5ccc4b2da77a4d5ec9f2086107bce1abedf9fc760"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.8.5/pact-broker-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "baeff50a997ba5916096b12289f36a75f40564e41c4579986cabc2b8416509ac"
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
