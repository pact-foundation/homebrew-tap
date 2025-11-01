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
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.5.0/pact-broker-cli-x86_64-macos"
      sha256 "3e4ef399c2b2fd615c8a3d84af7d894b50540ce40a7f882c279f05d7aaa2332c"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.5.0/pact-broker-cli-aarch64-macos"
      sha256 "447fe8990ec6716bd3688e570c8a080bb685ae1d2427aa223b41766786b26f79"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.5.0/pact-broker-cli-x86_64-linux-musl"
      sha256 "f6ef13685b78b9eb92285bdfd64f45317a3e71433e9e873d2835f13c17bf832e"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-broker-cli/releases/download/v0.5.0/pact-broker-cli-aarch64-linux-musl"
      sha256 "f3f3f10afc907e3db66e66f37379d8cda09e958a411b582ab46d85ba1bb160e2"
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
