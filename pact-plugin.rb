class PactPlugin < Formula
  desc "Standalone Pact Plugin CLI executable"
  homepage "https://github.com/pact-foundation/pact-plugins"
  version "0.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v0.3.1/pact-plugin-macos-aarch64.gz"
      sha256 "a82a0de868e2f1bba79124443280f1d36bb98210ee77f1e6517f3384fe4ccdf6"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v0.3.1/pact-plugin-macos-x86_64.gz"
      sha256 "eaa230a3746e962cd2b04b3cc0a0069b64d96355dc4776a8197dc52a42f32637"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v0.3.1/pact-plugin-linux-aarch64.gz"
      sha256 "d14bf918fedf8d03ecafb398e9a00575c35c4b1b22511266d9a53c42a513eb3a"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v0.3.1/pact-plugin-linux-x86_64.gz"
      sha256 "1583b3778cdcc4ea239a6ae342e007397f4334f59f4834bf1af7d07a0a6fc17a"
    end
  end

  def install
    bin.install Dir["*"]
    puts "# Run 'pact-plugin --help'"
  end

  test do
    system bin/"pact-plugin", "list", "known"
    assert_match "protobuf", shell_output("#{bin}/pact-plugin list known")
    assert_match "csv", shell_output("#{bin}/pact-plugin list known")
    assert_match "avro", shell_output("#{bin}/pact-plugin list known")
  end
end
