class PactVerifier < Formula
  desc "Standalone Pact Verifier CLI executable using the Rust Pact impl"
  homepage "https://github.com/pact-foundation/pact-reference"
  version "1.3.0"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.0/pact-verifier-macos-aarch64.gz"
      sha256 "af9a67b88a865df005ba3c66b41d090217f85155429a0f084581fca5d3d28587"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.0/pact-verifier-macos-x86_64.gz"
      sha256 "5aa75c898cc2efd31bb84a41ff5430a0ff71566f5113159b1c2d3117949d11b5"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.0/pact-verifier-linux-aarch64.gz"
      sha256 "f15a524147221668f567dca99e5b436a828d4cb2b6edfbed8e200ecacc45c7e3"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.0/pact-verifier-linux-x86_64.gz"
      sha256 "884aee8bd1096a8723019c7284aa0e2e5f704852c443a3ba0ee2ce7319431100"
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
