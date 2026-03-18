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
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.6.3/pact-broker-cli-x86_64-macos"
      sha256 "3a7497e1956a60c2b898794dcd03981462fd1909ba7b4983e57d303eae7d9a93"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.6.3/pact-broker-cli-aarch64-macos"
      sha256 "3b1f0e834f604a39caaacfc9ff05ec272812f1c924580c5fe66551317579f6fa"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.6.3/pact-broker-cli-x86_64-linux-musl"
      sha256 "e42ee13d4cb628ba1e0ca09c40ffe528f4866dcfbf0d11808c73818c97f2038d"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.6.3/pact-broker-cli-aarch64-linux-musl"
      sha256 "23b6628b80f6c7a8a88e8bcfdca472e932e45cb156fe49b20dd7e6a8347ad0cc"
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
