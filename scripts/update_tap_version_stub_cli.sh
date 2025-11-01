#!/bin/sh
set -e

homepage="https://github.com/pact-foundation/pact-stub-server"
version=$1
DESCRIPTION="Standalone Pact Stub Server executable"
TOOL_NAME=pact-stub-server
TOOL_NAME_PASCAL=PactStubServer
APP_NAME="pact-stub-server"
MAJOR_TAG=$(echo $version | cut -d '.' -f 1)
MINOR_TAG=$(echo $version | cut -d '.' -f 2)
PATCH_TAG=$(echo $version | cut -d '.' -f 3)
FORMULAE_FILE="$APP_NAME.rb"
FORMULA_NAME="$TOOL_NAME_PASCAL"

write_homebrew_formulae() {
    if [ ! -f "$FORMULAE_FILE" ] ; then
        touch "$FORMULAE_FILE"
    else
        : > "$FORMULAE_FILE"
    fi

    filename_macos_arm=v$version/$APP_NAME-macos-aarch64.gz
    filename_macos_x64=v$version/$APP_NAME-macos-x86_64.gz
    filename_linux_arm=v$version/$APP_NAME-linux-aarch64.gz
    filename_linux_x64=v$version/$APP_NAME-linux-x86_64.gz

    exec 3<> $FORMULAE_FILE
        echo "class $FORMULA_NAME < Formula" >&3
        echo "  desc \"$DESCRIPTION\"" >&3
        echo "  homepage \"$homepage\"" >&3
        echo "  version \"$version\"" >&3
        echo "  license \"MIT\"" >&3
        echo "" >&3
        echo "  on_macos do" >&3
        if [[ $sha_macos_arm64 ]]; then
        echo "    on_arm do" >&3
        echo "      url \"$homepage/releases/download/$filename_macos_arm\"" >&3
        echo "      sha256 \"${sha_macos_arm64}\"" >&3
        echo "    end" >&3
        fi
        echo "    on_intel do" >&3
        echo "      url \"$homepage/releases/download/$filename_macos_x64\"" >&3
        echo "      sha256 \"${sha_macos_x86_64}\"" >&3
        echo "    end" >&3
        echo "  end" >&3
        echo "" >&3
        echo "  on_linux do" >&3
        if [[ $sha_linux_arm64 ]]; then
        echo "    on_arm do" >&3
        echo "      url \"$homepage/releases/download/$filename_linux_arm\"" >&3
        echo "      sha256 \"${sha_linux_arm64}\"" >&3
        echo "    end" >&3
        fi
        echo "    on_intel do" >&3
        echo "      url \"$homepage/releases/download/$filename_linux_x64\"" >&3
        echo "      sha256 \"${sha_linux_x86_64}\"" >&3
        echo "    end" >&3
        echo "  end" >&3
        echo "" >&3
        echo "  def install" >&3
        echo "    bin.install Dir[\"*\"]" >&3
        echo "    puts \"# Run '$APP_NAME --help'\"" >&3
        echo "  end" >&3
        echo "" >&3
        echo "  test do" >&3
        echo "    system bin/\"$APP_NAME\", \"--help\"" >&3
        echo "" >&3
        echo "    # Test that we can create a simple pact file (mock functionality)" >&3
        echo "    test_pact = testpath/\"test.json\"" >&3
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
        echo "    pid = spawn(\"#{bin}/$APP_NAME --file #{test_pact} --port #{port}\")" >&3
        echo "    sleep 2 # Give server time to start" >&3
        echo "" >&3
        echo "    begin" >&3
        echo "      response = shell_output(\"curl -s http://localhost:#{port}/test\")" >&3
        echo "      assert_match \"test response\", response" >&3
        echo "    ensure" >&3
        echo "      Process.kill(\"TERM\", pid)" >&3
        echo "      Process.wait(pid)" >&3
        echo "    end" >&3
        echo "  end" >&3
        echo "end" >&3
    exec 3>&-
}

display_help() {
    echo "This script must be run from the root folder."
}

display_usage() {
    echo "\nCreate a versionsed formula of $TOOL_NAME\"\n"
    echo "\nUsage:\n\"./scripts/update_tap_version_plugin_cli.sh 1.64.1\"\n"
    echo "\nCreate a pull request at end on run\"\n"
    echo "\nUsage:\n\"CREATE_PR=true ./scripts/update_tap_version_plugin_cli.sh 1.64.1\"\n"
    echo "\nCreate as latest version\"\n"
    echo "\nUsage:\n\"LATEST=true ./scripts/update_tap_version_plugin_cli.sh 1.64.1\"\n"
}

if [[ $# -eq 0 ]] ; then
    echo "🚨 Please supply the $TOOL_NAME version to upgrade to"
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

        filename=$APP_NAME-${platform}-${arch}

        echo "⬇️  Downloading $version $filename.gz from $homepage"
        curl -LO $homepage/releases/download/v$version/$filename.gz

        brewshasignature=( $(eval "openssl dgst -sha256 $filename.gz") )
        echo "🔏 Checksum SHA256:\t ${brewshasignature[1]} for ${arch}"




        echo "⬇️  Downloading $version $filename.gz.sha256 for ${platform}-${arch}"
        echo "curl -LO $homepage/releases/download/v$version/$filename.gz.sha256"
        curl -LO $homepage/releases/download/v$version/$filename.gz.sha256

        expectedsha=( $(eval "cat $filename.gz.sha256") )
        echo "🔏 Expected SHA1:\t ${expectedsha[0]} for ${platform}-${arch}"

        if [ "${brewshasignature[1]}" == "${expectedsha[0]}" ]; then
            echo "👮‍♀️ SHA Check: 👍 for ${arch}"
        else
            echo "👮‍♀️ SHA Check: 🚨 - checksums do not match! for ${arch}"
            exit 1
        fi
        echo "🧹 Cleaning up..."
        rm $filename.gz
        rm $filename.gz.sha256
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

        hub pull-request --message "chore(release): Update version to v${version}"
        echo "🎉 Done!"
    fi


    exit 0
fi