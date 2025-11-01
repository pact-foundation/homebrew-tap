class PactPlugin < Formula
  desc "Standalone Pact Plugin CLI executable"
  homepage "https://github.com/pact-foundation/pact-plugins"
  version "0.2.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v0.2.0/pact-plugin-macos-aarch64.gz"
      sha256 "7045569e372b83d375011e4479fe7177b06d934eae318d661df1362244709501"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v0.2.0/pact-plugin-macos-x86_64.gz"
      sha256 "6aa28d92ac5f557ac0faea4790bb5079f5cb9e7ad750618cb58008750958b141"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v0.2.0/pact-plugin-linux-aarch64.gz"
      sha256 "b0b78702ccf8c054e7675d0d88da0281f66782890c3829b650bcebe2159b76cf"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-plugins/releases/download/pact-plugin-cli-v0.2.0/pact-plugin-linux-x86_64.gz"
      sha256 "98dceeb3efd0a5390fdfb7525225098efac8a2591032ca8401181fe799c51886"
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
