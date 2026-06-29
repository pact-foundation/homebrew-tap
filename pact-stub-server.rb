class PactStubServer < Formula
  desc "Standalone Pact Stub Server executable"
  homepage "https://github.com/pact-foundation/pact-stub-server"
  version "0.7.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-stub-server/releases/download/v0.7.1/pact-stub-server-macos-aarch64.gz"
      sha256 "81eff44b5e2a0142491df100f0a399862e6e111d2728d5ba1255bc92f92fc85b"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-stub-server/releases/download/v0.7.1/pact-stub-server-macos-x86_64.gz"
      sha256 "d9eb14a2ef188386b09f84a8f16bdf5de307227811e38b92b14cfbb8676fa1c8"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pact-foundation/pact-stub-server/releases/download/v0.7.1/pact-stub-server-linux-aarch64.gz"
      sha256 "35d6daf376a24923f6c7ad7f6802f1d132c9ec32fa9a395c3b2d27e353ffeb24"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-stub-server/releases/download/v0.7.1/pact-stub-server-linux-x86_64.gz"
      sha256 "6d7711b2c402749f50f615c16b9f09a896e0129bb9c4d10f4e321754003cc7a1"
    end
  end

  def install
    bin.install Dir["*"]
    puts "# Run 'pact-stub-server --help'"
  end

  test do
    system bin/"pact-stub-server", "--help"

    # Test that we can create a simple pact file (mock functionality)
    test_pact = testpath/"test.json"
    test_pact.write <<~EOS
      {
        "consumer": { "name": "TestConsumer" },
        "provider": { "name": "TestProvider" },
        "interactions": [
          {
            "description": "a test interaction",
            "request": {
              "method": "GET",
              "path": "/test"
            },
            "response": {
              "status": 200,
              "body": "test response"
            }
          }
        ],
        "metadata": {
          "pactSpecification": { "version": "2.0.0" }
        }
      }
    EOS

    # Test that stub server can start and respond with the pact file
    port = 9999
    pid = spawn("#{bin}/pact-stub-server --file #{test_pact} --port #{port}")
    sleep 2 # Give server time to start

    begin
      response = shell_output("curl -s http://localhost:#{port}/test")
      assert_match "test response", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
