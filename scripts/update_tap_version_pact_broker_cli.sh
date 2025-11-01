#!/bin/sh
set -e

homepage="https://github.com/pact-foundation/pact-broker-cli"
version=$1
FORMULAE_FILE="pact-broker-client.rb"
APP_NAME="pact-broker-cli"
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
            echo "class PactBrokerClient < Formula" >&3
            echo "  desc \"Client for interacting with Pact Broker\"" >&3
            echo "  homepage \"https://github.com/pact-foundation/pact-broker-cli\"" >&3
            echo "  url \"https://github.com/pact-foundation/pact-broker-cli.git\"" >&3
            echo "  license \"MIT\"" >&3
            echo "" >&3
            echo "  livecheck do" >&3
            echo "    url :stable" >&3
            echo "    strategy :github_latest" >&3
            echo "  end" >&3
            echo "" >&3
            echo "  head do" >&3
            echo "    url \"https://github.com/pact-foundation/pact-broker-cli.git\", branch: \"main\"" >&3
            echo "    depends_on \"rust\" => :build" >&3
            echo "  end" >&3
            echo "" >&3
            echo "  on_macos do" >&3
            echo "    on_intel do" >&3
            echo "      url \"https://github.com/pact-foundation/pact-broker-cli/releases/download/$filename_macos_x64\"" >&3
            echo "      sha256 \"${sha_macos_x86_64}\"" >&3
            echo "    end" >&3
            echo "" >&3
            echo "    on_arm do" >&3
            echo "      url \"https://github.com/pact-foundation/pact-broker-cli/releases/download/$filename_macos_arm\"" >&3
            echo "      sha256 \"${sha_macos_arm64}\"" >&3
            echo "    end" >&3
            echo "  end" >&3
            echo "" >&3
            echo "  on_linux do" >&3
            echo "    on_intel do" >&3
            echo "      url \"https://github.com/pact-foundation/pact-broker-cli/releases/download/$filename_linux_x64\"" >&3
            echo "      sha256 \"${sha_linux_x86_64}\"" >&3
            echo "    end" >&3
            echo "" >&3
            echo "    on_arm do" >&3
            echo "      url \"https://github.com/pact-foundation/pact-broker-cli/releases/download/$filename_linux_arm\"" >&3
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
            echo "        bin.install \"$APP_NAME-x86_64-macos\" => \"pact-broker-client\"" >&3
            echo "      else" >&3
            echo "        bin.install \"$APP_NAME-aarch64-macos\" => \"pact-broker-client\"" >&3
            echo "      end" >&3
            echo "    elsif OS.linux?" >&3
            echo "      if Hardware::CPU.intel?" >&3
            echo "        bin.install \"$APP_NAME-x86_64-linux-musl\" => \"pact-broker-client\"" >&3
            echo "      else" >&3
            echo "        bin.install \"$APP_NAME-aarch64-linux-musl\" => \"pact-broker-client\"" >&3
            echo "      end" >&3
            echo "    end" >&3
            echo "  end" >&3
            echo "" >&3
            echo "  test do" >&3
            echo "    # Test that the binary is properly linked and executable" >&3
            echo "    assert_predicate bin/\"pact-broker-client\", :executable?" >&3
            echo "" >&3
            echo "    # Test error handling - invalid command should fail gracefully" >&3
            echo "    shell_output(\"#{bin}/pact-broker-client invalid-command\", 2)" >&3
            echo "" >&3
            echo "    # Test the pact-broker-client command with an inaccessible broker" >&3
            echo "    args = [" >&3
            echo "      \"list-latest-pact-versions\"," >&3
            echo "      \"--broker-base-url\"," >&3
            echo "      \"http://localhost:9292\"," >&3
            echo "    ]" >&3
            echo "    output = shell_output(\"#{bin}/pact-broker-client #{args.join(\" \")} 2>&1\", 1)" >&3
            echo "" >&3
            echo "    # Should fail gracefully when broker is not accessible" >&3
            echo "    assert_match(/Failed to access pact broker/, output)" >&3
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
    echo "🚨 Please supply the pact-standalone version to upgrade to"
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
