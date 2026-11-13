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
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.9.0/pact-broker-cli-x86_64-apple-darwin.tar.xz"
      sha256 "bfb24b0f79d61866f77aefc2ef6a5be588b8e469605808c477785d76db9d8e87"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.9.0/pact-broker-cli-aarch64-apple-darwin.tar.xz"
      sha256 "bfbf739ef23e0696538b4bae46f78b4e9ef8bf6cd1518e940cca6dbb68d0218b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.9.0/pact-broker-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "eb888b9582c3f9a4136c7a74bce24cede923ff535d67d0c785346126370b6cb2"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.9.0/pact-broker-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f62f9696e94568c6ab315c376c40fa5b445eb9aec1fd1a82e9f418957c2427c8"
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
