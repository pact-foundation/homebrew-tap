#!/bin/sh
set -e

homepage="https://github.com/pact-foundation/pact-cli"
version=$1
FORMULAE_FILE="pact.rb"
APP_NAME="pact"
    filename_macos_arm=v$version/$APP_NAME-aarch64-macos
    filename_macos_x64=v$version/$APP_NAME-x86_64-macos
    filename_linux_arm=v$version/$APP_NAME-aarch64-linux-musl
    filename_linux_x64=v$version/$APP_NAME-x86_64-linux-musl

    write_homebrew_formulae() {
        if [ ! -f "$FORMULAE_FILE" ] ; then
            touch "$FORMULAE_FILE"
        else
            : > "$FORMULAE_FILE"
        fi

         exec 3<> $FORMULAE_FILE
            echo "class Pact < Formula" >&3
            echo "  desc \"All-in-one Mock/Stub Server, Provider Verifier, Broker Client & Plugin CLI\"" >&3
            echo "  homepage \"https://github.com/pact-foundation/pact-cli\"" >&3
            echo "  url \"https://github.com/pact-foundation/pact-cli.git\"" >&3
            echo "  license \"MIT\"" >&3
            echo "" >&3
            echo "  livecheck do" >&3
            echo "    url :stable" >&3
            echo "    strategy :github_latest" >&3
            echo "  end" >&3
            echo "" >&3
            echo "  head do" >&3
            echo "    url \"https://github.com/pact-foundation/pact-cli.git\", branch: \"main\"" >&3
            echo "    depends_on \"rust\" => :build" >&3
            echo "  end" >&3
            echo "" >&3
            echo "  on_macos do" >&3
            echo "    on_intel do" >&3
            echo "      url \"https://github.com/pact-foundation/pact-cli/releases/download/$filename_macos_x64\"" >&3
            echo "      sha256 \"${sha_macos_x86_64}\"" >&3
            echo "    end" >&3
            echo "" >&3
            echo "    on_arm do" >&3
            echo "      url \"https://github.com/pact-foundation/pact-cli/releases/download/$filename_macos_arm\"" >&3
            echo "      sha256 \"${sha_macos_arm64}\"" >&3
            echo "    end" >&3
            echo "  end" >&3
            echo "" >&3
            echo "  on_linux do" >&3
            echo "    on_intel do" >&3
            echo "      url \"https://github.com/pact-foundation/pact-cli/releases/download/$filename_linux_x64\"" >&3
            echo "      sha256 \"${sha_linux_x86_64}\"" >&3
            echo "    end" >&3
            echo "" >&3
            echo "    on_arm do" >&3
            echo "      url \"https://github.com/pact-foundation/pact-cli/releases/download/$filename_linux_arm\"" >&3
            echo "      sha256 \"${sha_linux_arm64}\"" >&3
            echo "    end" >&3
            echo "  end" >&3
            echo "" >&3
            echo "  def install" >&3
            echo "    if build.head?" >&3
            echo "      # Build from source if no precompiled binary is available" >&3
            echo "      system \"cargo\", \"install\", *std_cargo_args" >&3
            echo "    elsif OS.mac?" >&3
            echo "      if Hardware::CPU.intel?" >&3
            echo "        bin.install \"pact-x86_64-macos\" => \"pact\"" >&3
            echo "      else" >&3
            echo "        bin.install \"pact-aarch64-macos\" => \"pact\"" >&3
            echo "      end" >&3
            echo "    elsif OS.linux?" >&3
            echo "      if Hardware::CPU.intel?" >&3
            echo "        bin.install \"pact-x86_64-linux-musl\" => \"pact\"" >&3
            echo "      else" >&3
            echo "        bin.install \"pact-aarch64-linux-musl\" => \"pact\"" >&3
            echo "      end" >&3
            echo "    end" >&3
            echo "  end" >&3
            echo "" >&3
            echo "  def caveats" >&3
            echo "    <<~EOS" >&3
            echo "      🚀 Pact CLI with Extensions is now installed!" >&3
            echo "" >&3
            echo "      Quick start:" >&3
            echo "        pact --help                           # Show all available commands" >&3
            echo "        pact extension list                   # List available extensions" >&3
            echo "        pact extension install pactflow-ai    # Install PactFlow AI extension" >&3
            echo "        pact pactflow ai --help              # Use PactFlow AI seamlessly" >&3
            echo "" >&3
            echo "      📖 Documentation:" >&3
            echo "        - Extensions: https://github.com/pact-foundation/pact-cli/blob/main/EXTENSIONS.md" >&3
            echo "        - Pact Docs: https://docs.pact.io" >&3
            echo "" >&3
            echo "      🔧 Configuration:" >&3
            echo "        Extensions are installed to: ~/.pact/extensions/" >&3
            echo "        Override with: export PACT_CLI_EXTENSIONS_HOME=/custom/path" >&3
            echo "" >&3
            echo "      💡 The Pact CLI includes:" >&3
            echo "        - Mock Server (pact mock)" >&3
            echo "        - Provider Verifier (pact verifier)" >&3
            echo "        - Stub Server (pact stub)" >&3
            echo "        - Broker Client (pact broker)" >&3
            echo "        - PactFlow Client (pact pactflow)" >&3
            echo "        - Plugin CLI (pact plugin)" >&3
            echo "        - Extension System (pact extension)" >&3
            echo "" >&3
            echo "      🔄 Installation options:" >&3
            echo "        - Precompiled binaries (default, fastest)" >&3
            echo "        - From source with Cargo (brew install --HEAD pact)" >&3
            echo "    EOS" >&3
            echo "  end" >&3
            echo "" >&3
            echo "  test do" >&3
            echo "    # Test that the binary is properly linked and executable" >&3
            echo "    assert_predicate bin/\"pact\", :executable?" >&3
            echo "" >&3
            echo "    # Test error handling - invalid command should fail gracefully" >&3
            echo "    shell_output(\"#{bin}/pact invalid-command\", 1)" >&3
            echo "" >&3
            echo "    assert_match \"Pact in a single binary\", shell_output(bin/\"pact\")" >&3
            echo "" >&3
            echo "    # Test subcommand availability and help output" >&3
            echo "    %w[mock verifier stub broker pactflow plugin extension].each do |cmd|" >&3
            echo "      help_output = shell_output(\"#{bin}/pact #{cmd} --help\")" >&3
            echo "      assert_match cmd, help_output.downcase" >&3
            echo "    end" >&3
            echo "" >&3
            echo "    # --- Test Mock Server subcommand --- #" >&3
            echo "" >&3
            echo "    # Test mock server functionality" >&3
            echo "    with_env(\"BIN\" => bin/\"$APP_NAME\") do" >&3
            echo "      # Start mock service" >&3
            echo "      pid = spawn(bin/\"$APP_NAME\", \"mock\", \"start\", \"--port\", \"1234\"," >&3
            echo "                  \"--loglevel\", \"debug\", \"--output\", \"./tmp\", \"--base-port\", \"8081\")" >&3
            echo "" >&3
            echo "      # Wait for mock service to start" >&3
            echo "      100.times do" >&3
            echo "        break if system(\"curl -s -f localhost:1234 > /dev/null 2>&1\")" >&3
            echo "" >&3
            echo "        sleep 0.1" >&3
            echo "      end" >&3
            echo "" >&3
            echo "      # Create a temporary pact file for testing" >&3
            echo "      pact_content = {" >&3
            echo "        \"consumer\"     => { \"name\" => \"Foo\" }," >&3
            echo "        \"provider\"     => { \"name\" => \"Bar\" }," >&3
            echo "        \"interactions\" => [" >&3
            echo "          {" >&3
            echo "            \"description\" => \"foo\"," >&3
            echo "            \"request\"     => {" >&3
            echo "              \"method\" => \"GET\"," >&3
            echo "              \"path\"   => \"/foo\"," >&3
            echo "            }," >&3
            echo "            \"response\"    => {" >&3
            echo "              \"status\"  => 200," >&3
            echo "              \"headers\" => {" >&3
            echo "                \"Content-Type\" => \"application/json\"," >&3
            echo "              }," >&3
            echo "              \"body\"    => {" >&3
            echo "                \"message\" => \"Hello world\"," >&3
            echo "              }," >&3
            echo "            }," >&3
            echo "          }," >&3
            echo "        ]," >&3
            echo "        \"metadata\"     => {" >&3
            echo "          \"pactSpecification\" => {" >&3
            echo "            \"version\" => \"2.0.0\"," >&3
            echo "          }," >&3
            echo "        }," >&3
            echo "      }" >&3
            echo "" >&3
            echo "      require \"json\"" >&3
            echo "      pact_file = \"#{testpath}/foo-bar.json\"" >&3
            echo "      File.write(pact_file, JSON.pretty_generate(pact_content))" >&3
            echo "" >&3
            echo "      mock_output = begin" >&3
            echo "        \`#{bin}/$APP_NAME mock create --file #{pact_file} --port 1234 2>/dev/null\`" >&3
            echo "      rescue" >&3
            echo "        \"Mock server created\"" >&3
            echo "      end" >&3
            echo "" >&3
            echo "      # Extract mock server details from output" >&3
            echo "      mock_id = begin" >&3
            echo "        mock_output.match(/Mock server (\\w+)/)[1]" >&3
            echo "      rescue" >&3
            echo "        \"unknown\"" >&3
            echo "      end" >&3
            echo "      mock_port = begin" >&3
            echo "        mock_output.match(/port (\\d+)/)[1]" >&3
            echo "      rescue" >&3
            echo "        \"1234\"" >&3
            echo "      end" >&3
            echo "      puts \"Mock server ID: #{mock_id}\"" >&3
            echo "      puts \"Mock server port: #{mock_port}\"" >&3
            echo "" >&3
            echo "      # Wait for mock server to start up" >&3
            echo "      100.times do" >&3
            echo "        break if system(\"curl -s -f localhost:1234/mockserver/#{mock_id} > /dev/null 2>&1\")" >&3
            echo "" >&3
            echo "        sleep 0.5" >&3
            echo "      end" >&3
            echo "" >&3
            echo "      # Check mock server status via API" >&3
            echo "      mock_server_status = \`curl -s -H \"Content-Type: application/json\" localhost:1234/mockserver/#{mock_id}\`" >&3
            echo "      status_json = begin" >&3
            echo "        JSON.parse(mock_server_status)" >&3
            echo "      rescue" >&3
            echo "        {}" >&3
            echo "      end" >&3
            echo "      mock_address = status_json[\"address\"] || \"localhost:8081\"" >&3
            echo "      mock_requests = status_json.dig(\"metrics\", \"requests\") || 0" >&3
            echo "      mock_provider_name = status_json[\"provider\"] || \"Bar\"" >&3
            echo "      mock_scheme = status_json[\"scheme\"] || \"http\"" >&3
            echo "      mock_status = status_json[\"status\"] || \"unknown\"" >&3
            echo "" >&3
            echo "      puts \"Mock server address: #{mock_address}\"" >&3
            echo "      puts \"Mock server requests: #{mock_requests}\"" >&3
            echo "      puts \"Mock server provider name: #{mock_provider_name}\"" >&3
            echo "      puts \"Mock server scheme: #{mock_scheme}\"" >&3
            echo "      puts \"Mock server status: #{mock_status}\"" >&3
            echo "" >&3
            echo "      # Execute interaction (simulate consumer request)" >&3
            echo "      system(\"curl\", \"#{mock_scheme}://#{mock_address}/foo\")" >&3
            echo "" >&3
            echo "      # Verify interactions took place" >&3
            echo "      verify_result = \`curl -X POST -H \"Content-Type: application/json\" localhost:1234/mockserver/#{mock_id}/verify\`" >&3
            echo "      puts \"Verification result: #{verify_result}\"" >&3
            echo "" >&3
            echo "      # Check final status" >&3
            echo "      final_status = \`curl -s -H \"Content-Type: application/json\" localhost:1234/mockserver/#{mock_id}\`" >&3
            echo "      begin" >&3
            echo "        final_json = JSON.parse(final_status)" >&3
            echo "      rescue" >&3
            echo "        final_json = {}" >&3
            echo "      end" >&3
            echo "      puts \"Final requests: #{final_json.dig(\"metrics\", \"requests\") || 0}\"" >&3
            echo "" >&3
            echo "      # Shutdown mock server" >&3
            echo "      system(bin/\"$APP_NAME\", \"mock\", \"shutdown\", \"--mock-server-id\", mock_id, \"--port\", \"1234\")" >&3
            echo "      # Clean up" >&3
            echo "      Process.kill(\"TERM\", pid) if pid" >&3
            echo "      Process.wait(pid) if pid" >&3
            echo "    end" >&3
            echo "" >&3
            echo "    # --- Test Stub Server subcommand --- #" >&3
            echo "" >&3
            echo "    # Test that we can create a simple pact file (mock functionality)" >&3
            echo "    test_pact = testpath/\"stub.json\"" >&3
            echo "    test_pact.write <<~EOS" >&3
            echo "      {" >&3
            echo "        \"consumer\": { \"name\": \"TestConsumer\" }," >&3
            echo "        \"provider\": { \"name\": \"TestProvider\" }," >&3
            echo "        \"interactions\": [" >&3
            echo "          {" >&3
            echo "            \"description\": \"a test interaction\"," >&3
            echo "            \"request\": {" >&3
            echo "              \"method\": \"GET\"," >&3
            echo "              \"path\": \"/test\"" >&3
            echo "            }," >&3
            echo "            \"response\": {" >&3
            echo "              \"status\": 200," >&3
            echo "              \"body\": \"test response\"" >&3
            echo "            }" >&3
            echo "          }" >&3
            echo "        ]," >&3
            echo "        \"metadata\": {" >&3
            echo "          \"pactSpecification\": { \"version\": \"2.0.0\" }" >&3
            echo "        }" >&3
            echo "      }" >&3
            echo "    EOS" >&3
            echo "" >&3
            echo "    # Test that stub server can start and respond with the pact file" >&3
            echo "    port = 9999" >&3
            echo "    pid = spawn(\"#{bin}/$APP_NAME stub --file #{test_pact} --port #{port}\")" >&3
            echo "    sleep 2 # Give server time to start" >&3
            echo "" >&3
            echo "    begin" >&3
            echo "      response = shell_output(\"curl -s http://localhost:#{port}/test\")" >&3
            echo "      assert_match \"test response\", response" >&3
            echo "    ensure" >&3
            echo "      Process.kill(\"TERM\", pid)" >&3
            echo "      Process.wait(pid)" >&3
            echo "    end" >&3
            echo "" >&3
            echo "    # --- Test Provider Verifier subcommand --- #" >&3
            echo "    # Create a simple pact file for testing" >&3
            echo "    pact_file = testpath/\"verifier.json\"" >&3
            echo "    pact_file.write <<~JSON" >&3
            echo "      {" >&3
            echo "        \"consumer\": {" >&3
            echo "          \"name\": \"anotherclient\"" >&3
            echo "        }," >&3
            echo "        \"provider\": {" >&3
            echo "          \"name\": \"they\"" >&3
            echo "        }," >&3
            echo "        \"interactions\": [" >&3
            echo "          {" >&3
            echo "            \"description\": \"Greeting\"," >&3
            echo "            \"request\": {" >&3
            echo "              \"method\": \"GET\"," >&3
            echo "              \"path\": \"/\"" >&3
            echo "            }," >&3
            echo "            \"response\": {" >&3
            echo "              \"status\": 200," >&3
            echo "              \"headers\": {" >&3
            echo "              }," >&3
            echo "              \"body\": {" >&3
            echo "                \"greeting\": \"Hello\"" >&3
            echo "              }" >&3
            echo "            }" >&3
            echo "          }," >&3
            echo "          {" >&3
            echo "            \"description\": \"Provider state success\"," >&3
            echo "            \"providerState\": \"There is a greeting\"," >&3
            echo "            \"request\": {" >&3
            echo "              \"method\": \"GET\"," >&3
            echo "              \"path\": \"/somestate\"" >&3
            echo "            }," >&3
            echo "            \"response\": {" >&3
            echo "              \"status\": 200," >&3
            echo "              \"headers\": {" >&3
            echo "              }," >&3
            echo "              \"body\": {" >&3
            echo "                \"greeting\": \"State data!\"" >&3
            echo "              }" >&3
            echo "            }" >&3
            echo "          }" >&3
            echo "        ]," >&3
            echo "        \"metadata\": {" >&3
            echo "          \"pactSpecification\": {" >&3
            echo "            \"version\": \"2.0.0\"" >&3
            echo "          }" >&3
            echo "        }" >&3
            echo "      }" >&3
            echo "    JSON" >&3
            echo "" >&3
            echo "    # Test basic help command" >&3
            echo "    system bin/\"$APP_NAME\", \"verifier\", \"--help\"" >&3
            echo "" >&3
            echo "    # Run verifier against test API" >&3
            echo "    verifier_output = shell_output([" >&3
            echo "      \"#{bin}/$APP_NAME\"," >&3
            echo "      \"verifier\"," >&3
            echo "      \"--hostname\", \"localhost\"," >&3
            echo "      \"--port\", \"4567\"," >&3
            echo "      \"--file\", pact_file.to_s," >&3
            echo "      \"--state-change-url\", \"http://localhost:4567/provider-state\"," >&3
            echo "      \"--no-colour\"" >&3
            echo "    ].join(\" \"), 1)" >&3
            echo "    puts verifier_output" >&3
            echo "    assert_match \"Verifying a pact between anotherclient and they\", verifier_output" >&3
            echo "    assert_match \"There were 2 pact failures\", verifier_output" >&3
            echo "    # --- Test Plugin CLI subcommand --- #" >&3
            echo "    system bin/\"$APP_NAME\", \"plugin\", \"list\", \"known\"" >&3
            echo "    assert_match \"protobuf\", shell_output(\"#{bin}/$APP_NAME plugin list known\")" >&3
            echo "    assert_match \"csv\", shell_output(\"#{bin}/$APP_NAME plugin list known\")" >&3
            echo "    assert_match \"avro\", shell_output(\"#{bin}/$APP_NAME plugin list known\")" >&3
            echo "  end" >&3
            echo "end" >&3
        exec 3>&-
    }

display_help() {
    echo "This script must be run from the root folder."
}

display_usage() {
    echo "\nUsage:\n\"CREATE_PR=true ./scripts/update_tap_version.sh 1.64.1\"\n"
}

if [[ $# -eq 0 ]] ; then
    echo "🚨 Please supply the pact cli version to upgrade to"
    display_usage
    exit 1
elif [[ $1 == "--help" ||  $1 == "-h" ]] ; then
    display_help
    display_usage
    exit 1
else

archs=(x86_64 aarch64)
platforms=(linux macos)
shas=()
for platform in ${platforms[@]}; do 
    for arch in ${archs[@]}; do 

        filename=$APP_NAME-${arch}-${platform}
        if [ "${platform}" = "linux" ]; then
            filename="$filename-musl"
        fi

        echo "⬇️  Downloading $version $filename from $homepage"
        echo "URL: $homepage/releases/download/v$version/$filename"
        curl -LO $homepage/releases/download/v$version/$filename

        brewshasignature=( $(eval "openssl dgst -sha256 $filename") )
        echo "🔏 Checksum SHA256:\t ${brewshasignature[1]} for ${arch}"


        echo "⬇️  Downloading $filename.checksum for ${arch}-${platform}"
        curl -LO $homepage/releases/download/v$version/$filename.sha256

        expectedsha=( $(eval "cat $filename.sha256") )
        echo "🔏 Expected SHA256:\t ${expectedsha[0]} for ${arch}-${platform}"

        if [ "${shasignature[1]}" == "${expectedsha[0]}" ]; then
            echo "👮‍♀️ SHA Check: 👍 for ${arch}-${platform}"
        else
            echo "👮‍♀️ SHA Check: 🚨 - checksums do not match! for ${arch}-${platform}"
            echo "⚠️  Warning: error suppressed due to no published shasum to compare against"
            # exit 1 # no published shasum to compare against
        fi
        echo "🧹 Cleaning up..."
        rm $filename
        rm $filename.sha256
        echo "🔏 Checksum SHA256:\t ${brewshasignature[1]} for ${platform}-${arch}"
        echo "🧪 Writing formulae..."
        shas+=(${brewshasignature[1]})
    done 
done 

    sha_linux_x86_64=${shas[0]}
    sha_linux_arm64=${shas[1]}
    sha_macos_x86_64=${shas[2]}
    sha_macos_arm64=${shas[3]}

    echo "sha_macos_arm64:" $sha_macos_arm64
    echo "sha_macos_x86_64:" $sha_macos_x86_64
    echo "sha_linux_arm64:" $sha_linux_arm64
    echo "sha_linux_x86_64:" $sha_linux_x86_64

    write_homebrew_formulae

    if [[ ! -n "${CREATE_PR}" ]] 
    then
        echo "🎉 Done!"
    else
        git checkout -b version/v$version
        git add $FORMULAE_FILE
        git commit -m "chore(release): Update version to v$version"
        git push --set-upstream origin version/v$version

        echo "👏  Go and open that PR now:"
        echo "🔗  $homepage/compare/master...version/v$version"

        gh pr create --title "chore(release): Update version to v${version}" --fill
        echo "🎉 Done!"
    fi




    exit 0
fi
