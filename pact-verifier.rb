class PactVerifier < Formula
  desc "Standalone Pact Verifier CLI executable using the Rust Pact impl"
  homepage "https://github.com/pact-foundation/pact-reference"
  version "1.5.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.5.0/pact-verifier-macos-aarch64.gz"
      sha256 "e663f9c97cdef2e9aab4c78faec9f6781f058d549693a9ecaced63cd70122edd"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.5.0/pact-verifier-macos-x86_64.gz"
      sha256 "63f86d7f55114e9368b4f3e52fcb760609e8fe3d1824ec5289358258762beb41"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.5.0/pact-verifier-linux-aarch64.gz"
      sha256 "c39e46866951daa1f6e44853b98542803c5c05dc2d95ade8a10ff7e1ffb2639e"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.5.0/pact-verifier-linux-x86_64.gz"
      sha256 "a0e506dada568004ab523fcecd3491d151ec329e01aafd2d0e19d9e54b7c1a5e"
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
