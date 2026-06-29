class PactVerifier < Formula
  desc "Standalone Pact Verifier CLI executable using the Rust Pact impl"
  homepage "https://github.com/pact-foundation/pact-reference"
  version "1.3.3"
  license "MIT"

  on_macos do
    on_arm do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.3/pact-verifier-macos-aarch64.gz"
      sha256 "36de5001fd36ac3dbf5cb6d1b298b0c2d71c7afdaa721fdb54f38abe6bf517c9"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.3/pact-verifier-macos-x86_64.gz"
      sha256 "ef05423ae171b5440807b18c8c9a9cf936a4ca2fad8733898094ba6f9a8a9a3a"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.3/pact-verifier-linux-aarch64.gz"
      sha256 "cf1c3af966e3e70633c167abcc2d5c6db0dec9dd81f3ec896841f5d962cb4b40"
    end
    on_intel do
      url "https://github.com/pact-foundation/pact-reference/releases/download/pact_verifier_cli-v1.3.3/pact-verifier-linux-x86_64.gz"
      sha256 "411903f850d977b21a64d67c177900d812852ef486c4910c39854f281ab1c438"
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
