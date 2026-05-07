class PactVerifier < Formula
  desc "Standalone Pact Verifier CLI executable using the Rust Pact impl"
  homepage "https://github.com/pact-foundation/pact-reference"
  version "1.3.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.1/pact-verifier-macos-aarch64.gz"
      sha256 "dcc130d74c8b5a6a01da3fa9d860a0f557b5616e07ad1a31d2a191af833b193e"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.1/pact-verifier-macos-x86_64.gz"
      sha256 "fa70d923a7fa1f82f7cb52b61a1a60446e5e934710e805636031073c0876853f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.1/pact-verifier-linux-aarch64.gz"
      sha256 "9939d34ed2e07873e805b2e627bcd10bafa8abd22c4895980ba668c58a5602f6"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.1/pact-verifier-linux-x86_64.gz"
      sha256 "08bae33070117a7278a7c0d6cbfed821b6deda7321a303759ad64d1634e0ae57"
    end
  end

  def install
    bin.install Dir["*"]
    puts "# Run 'pact-verifier --help'"
  end

  test do
    # Create a simple pact file for testing
    pact_file = testpath/"test.json"
    pact_file.write <<~JSON
      {
        "consumer": {
          "name": "anotherclient"
        },
        "provider": {
          "name": "they"
        },
        "interactions": [
          {
            "description": "Greeting",
            "request": {
              "method": "GET",
              "path": "/"
            },
            "response": {
              "status": 200,
              "headers": {
              },
              "body": {
                "greeting": "Hello"
              }
            }
          },
          {
            "description": "Provider state success",
            "providerState": "There is a greeting",
            "request": {
              "method": "GET",
              "path": "/somestate"
            },
            "response": {
              "status": 200,
              "headers": {
              },
              "body": {
                "greeting": "State data!"
              }
            }
          }
        ],
        "metadata": {
          "pactSpecification": {
            "version": "2.0.0"
          }
        }
      }
    JSON

    # Test basic help command
    system bin/"pact-verifier", "--help"

    # Test that the binary exists and is executable
    assert_path_exists bin/"pact-verifier"
    assert_predicate bin/"pact-verifier", :executable?

    # Test version output
    output = shell_output("#{bin}/pact-verifier --version")
    assert_match version.to_s, output

    # Run verifier against test API
    verifier_output = shell_output([
      "#{bin}/pact-verifier",
      "--hostname", "localhost",
      "--port", "4567",
      "--file", pact_file.to_s,
      "--state-change-url", "http://localhost:4567/provider-state",
      "--no-colour"
    ].join(" "), 1)
    puts verifier_output
    assert_match "Verifying a pact between anotherclient and they", verifier_output
    assert_match "There were 2 pact failures", verifier_output
  end
end
