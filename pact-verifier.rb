class PactVerifier < Formula
  desc "Standalone Pact Verifier CLI executable using the Rust Pact impl"
  homepage "https://github.com/pact-foundation/pact-reference"
  version "1.5.1"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.5.1/pact-verifier-macos-aarch64.gz"
      sha256 "40fdad8d7c9bd20a10257905f14a9c7aea26916fcb085d0325de9d04525b70bb"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.5.1/pact-verifier-macos-x86_64.gz"
      sha256 "a5957824ce5558c305ff2599782f1793c73bfe203f5957565b363726a186190f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.5.1/pact-verifier-linux-aarch64.gz"
      sha256 "79ffd62ac38c7122ff69249a34aa0bb224f98e5793550ba9c257559609e83be3"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.5.1/pact-verifier-linux-x86_64.gz"
      sha256 "42d36282ffd477ab4770e29335747dead1eac3fab2bc850f7b8b94efa1d2fa67"
    end
  end

  def install
    # .gz release assets may not store the original filename, so install under a fixed name
    bin.install Dir["*"].first => "pact-verifier"
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
