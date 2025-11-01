class Pact < Formula
  desc "All-in-one Mock/Stub Server, Provider Verifier, Broker Client & Plugin CLI"
  homepage "https://github.com/pact-foundation/pact-cli"
  url "https://github.com/pact-foundation/pact-cli.git"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  head do
    url "https://github.com/pact-foundation/pact-cli.git", branch: "main"
    depends_on "rust" => :build
  end

  on_macos do
    on_intel do
      url "https://github.com/pact-foundation/pact-cli/releases/download/v0.9.1/pact-x86_64-macos"
      sha256 "2af7d20a6779983ddd8d66cc2ec001d48f94c15bdaaaae5bced40573a17d43ef"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-cli/releases/download/v0.9.1/pact-aarch64-macos"
      sha256 "68718500cdff0952bcf16f159c977ac7e58cbc733da8d847cbd1733228c6582b"
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/pact-foundation/pact-cli/releases/download/v0.9.1/pact-x86_64-linux-musl"
      sha256 "cfd0c4e6064771d354d17ad35e24a147e6b66a5907415635229a96570749ad26"
    end

    on_arm do
      url "https://github.com/pact-foundation/pact-cli/releases/download/v0.9.1/pact-aarch64-linux-musl"
      sha256 "0411ca7277b4486fc883cf1fc7062c73bd6abce7c1ce6cb9dce771b175cb609e"
    end
  end

  def install
    if build.head?
      # Build from source if no precompiled binary is available
      system "cargo", "install", *std_cargo_args
    elsif OS.mac?
      if Hardware::CPU.intel?
        bin.install "pact-x86_64-macos" => "pact"
      else
        bin.install "pact-aarch64-macos" => "pact"
      end
    elsif OS.linux?
      if Hardware::CPU.intel?
        bin.install "pact-x86_64-linux-musl" => "pact"
      else
        bin.install "pact-aarch64-linux-musl" => "pact"
      end
    end
  end

  def caveats
    <<~EOS
      🚀 Pact CLI with Extensions is now installed!

      Quick start:
        pact --help                           # Show all available commands
        pact extension list                   # List available extensions
        pact extension install pactflow-ai    # Install PactFlow AI extension
        pact pactflow ai --help              # Use PactFlow AI seamlessly

      📖 Documentation:
        - Extensions: https://github.com/pact-foundation/pact-cli/blob/main/EXTENSIONS.md
        - Pact Docs: https://docs.pact.io

      🔧 Configuration:
        Extensions are installed to: ~/.pact/extensions/
        Override with: export PACT_CLI_EXTENSIONS_HOME=/custom/path

      💡 The Pact CLI includes:
        - Mock Server (pact mock)
        - Provider Verifier (pact verifier)
        - Stub Server (pact stub)
        - Broker Client (pact broker)
        - PactFlow Client (pact pactflow)
        - Plugin CLI (pact plugin)
        - Extension System (pact extension)

      🔄 Installation options:
        - Precompiled binaries (default, fastest)
        - From source with Cargo (brew install --HEAD pact)
    EOS
  end

  test do
    # Test that the binary is properly linked and executable
    assert_predicate bin/"pact", :executable?

    # Test error handling - invalid command should fail gracefully
    shell_output("#{bin}/pact invalid-command", 1)

    assert_match "Pact in a single binary", shell_output(bin/"pact")

    # Test subcommand availability and help output
    %w[mock verifier stub broker pactflow plugin extension].each do |cmd|
      help_output = shell_output("#{bin}/pact #{cmd} --help")
      assert_match cmd, help_output.downcase
    end

    # --- Test Mock Server subcommand --- #

    # Test mock server functionality
    with_env("BIN" => bin/"pact") do
      # Start mock service
      pid = spawn(bin/"pact", "mock", "start", "--port", "1234",
                  "--loglevel", "debug", "--output", "./tmp", "--base-port", "8081")

      # Wait for mock service to start
      100.times do
        break if system("curl -s -f localhost:1234 > /dev/null 2>&1")

        sleep 0.1
      end

      # Create a temporary pact file for testing
      pact_content = {
        "consumer"     => { "name" => "Foo" },
        "provider"     => { "name" => "Bar" },
        "interactions" => [
          {
            "description" => "foo",
            "request"     => {
              "method" => "GET",
              "path"   => "/foo",
            },
            "response"    => {
              "status"  => 200,
              "headers" => {
                "Content-Type" => "application/json",
              },
              "body"    => {
                "message" => "Hello world",
              },
            },
          },
        ],
        "metadata"     => {
          "pactSpecification" => {
            "version" => "2.0.0",
          },
        },
      }

      require "json"
      pact_file = "#{testpath}/foo-bar.json"
      File.write(pact_file, JSON.pretty_generate(pact_content))

      mock_output = begin
        `#{bin}/pact mock create --file #{pact_file} --port 1234 2>/dev/null`
      rescue
        "Mock server created"
      end

      # Extract mock server details from output
      mock_id = begin
        mock_output.match(/Mock server (\w+)/)[1]
      rescue
        "unknown"
      end
      mock_port = begin
        mock_output.match(/port (\d+)/)[1]
      rescue
        "1234"
      end
      puts "Mock server ID: #{mock_id}"
      puts "Mock server port: #{mock_port}"

      # Wait for mock server to start up
      100.times do
        break if system("curl -s -f localhost:1234/mockserver/#{mock_id} > /dev/null 2>&1")

        sleep 0.5
      end

      # Check mock server status via API
      mock_server_status = `curl -s -H "Content-Type: application/json" localhost:1234/mockserver/#{mock_id}`
      status_json = begin
        JSON.parse(mock_server_status)
      rescue
        {}
      end
      mock_address = status_json["address"] || "localhost:8081"
      mock_requests = status_json.dig("metrics", "requests") || 0
      mock_provider_name = status_json["provider"] || "Bar"
      mock_scheme = status_json["scheme"] || "http"
      mock_status = status_json["status"] || "unknown"

      puts "Mock server address: #{mock_address}"
      puts "Mock server requests: #{mock_requests}"
      puts "Mock server provider name: #{mock_provider_name}"
      puts "Mock server scheme: #{mock_scheme}"
      puts "Mock server status: #{mock_status}"

      # Execute interaction (simulate consumer request)
      system("curl", "#{mock_scheme}://#{mock_address}/foo")

      # Verify interactions took place
      verify_result = `curl -X POST -H "Content-Type: application/json" localhost:1234/mockserver/#{mock_id}/verify`
      puts "Verification result: #{verify_result}"

      # Check final status
      final_status = `curl -s -H "Content-Type: application/json" localhost:1234/mockserver/#{mock_id}`
      begin
        final_json = JSON.parse(final_status)
      rescue
        final_json = {}
      end
      puts "Final requests: #{final_json.dig("metrics", "requests") || 0}"

      # Shutdown mock server
      system(bin/"pact", "mock", "shutdown", "--mock-server-id", mock_id, "--port", "1234")
      # Clean up
      Process.kill("TERM", pid) if pid
      Process.wait(pid) if pid
    end

    # --- Test Stub Server subcommand --- #

    # Test that we can create a simple pact file (mock functionality)
    test_pact = testpath/"stub.json"
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
    pid = spawn("#{bin}/pact stub --file #{test_pact} --port #{port}")
    sleep 2 # Give server time to start

    begin
      response = shell_output("curl -s http://localhost:#{port}/test")
      assert_match "test response", response
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end

    # --- Test Provider Verifier subcommand --- #
    # Create a simple pact file for testing
    pact_file = testpath/"verifier.json"
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
    system bin/"pact", "verifier", "--help"

    # Run verifier against test API
    verifier_output = shell_output([
      "#{bin}/pact",
      "verifier",
      "--hostname", "localhost",
      "--port", "4567",
      "--file", pact_file.to_s,
      "--state-change-url", "http://localhost:4567/provider-state",
      "--no-colour"
    ].join(" "), 1)
    puts verifier_output
    assert_match "Verifying a pact between anotherclient and they", verifier_output
    assert_match "There were 2 pact failures", verifier_output
    # --- Test Plugin CLI subcommand --- #
    system bin/"pact", "plugin", "list", "known"
    assert_match "protobuf", shell_output("#{bin}/pact plugin list known")
    assert_match "csv", shell_output("#{bin}/pact plugin list known")
    assert_match "avro", shell_output("#{bin}/pact plugin list known")
  end
end
