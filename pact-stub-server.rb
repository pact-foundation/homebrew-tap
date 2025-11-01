class PactStubServer < Formula
  desc "Standalone Pact Stub Server executable"
  homepage "https://github.com/pact-foundation/pact-stub-server"
  version "0.7.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-stub-server/releases/download/v0.7.0/pact-stub-server-macos-aarch64.gz"
      sha256 "89ab428f18cdbeb4fb9b08b8eb56a7a0239ca1dc87dac6dd66d21a36367b79b8"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-stub-server/releases/download/v0.7.0/pact-stub-server-macos-x86_64.gz"
      sha256 "0ba02f7d92f871f1adbe0e20ad6b6df126ee563deb66959c4ad5a39d7e29edc2"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pact-foundation/pact-stub-server/releases/download/v0.7.0/pact-stub-server-linux-aarch64.gz"
      sha256 "a069981c42f3ae8598d7ea75338edc319a4cda1a758b5fa6613a99218c056842"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-stub-server/releases/download/v0.7.0/pact-stub-server-linux-x86_64.gz"
      sha256 "6b53b4c50fc1e415560c0293b5e8483c4009a8f6f753ca1a77457a2f274ec71a"
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
