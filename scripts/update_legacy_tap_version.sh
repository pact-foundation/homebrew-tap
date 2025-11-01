#!/bin/sh
set -e

homepage="https://github.com/pact-foundation/pact-standalone"
version=$1
FORMULAE_FILE="pact-legacy.rb"

write_homebrew_formulae() {
    if [ ! -f "$FORMULAE_FILE" ] ; then
        touch "$FORMULAE_FILE"
    else
        : > "$FORMULAE_FILE"
    fi

     exec 3<> $FORMULAE_FILE
        echo "class PactLegacy < Formula" >&3
        echo "  desc \"Standalone pact CLI executable using the Ruby Pact impl and Traveling Ruby\"" >&3
        echo "  homepage \"$homepage\"" >&3
        echo "  version \"$version\"" >&3
        echo "  license \"MIT\"" >&3
        echo "  deprecate! date: \"2027-01-01\", because: :reason, replacement_formula: \"pact-foundation/tap/pact\"" >&3
        echo "" >&3
        echo "  on_macos do" >&3
        echo "    on_intel do" >&3
        echo "      url \"$homepage/releases/download/v$version/pact-$version-osx-x86_64.tar.gz\"" >&3
        echo "      sha256 \"${sha_osx_x86_64}\"" >&3
        echo "    end" >&3
        echo "    on_arm do" >&3
        echo "      url \"$homepage/releases/download/v$version/pact-$version-osx-arm64.tar.gz\"" >&3
        echo "      sha256 \"${sha_osx_arm64}\"" >&3
        echo "    end" >&3
        echo "  end" >&3
        echo "  on_linux do" >&3
        echo "    on_intel do" >&3
        echo "      url \"$homepage/releases/download/v$version/pact-$version-linux-x86_64.tar.gz\"" >&3
        echo "      sha256 \"${sha_linux_x86_64}\"" >&3
        echo "    end" >&3
        echo "    on_arm do" >&3
        echo "      url \"$homepage/releases/download/v$version/pact-$version-linux-arm64.tar.gz\"" >&3
        echo "      sha256 \"${sha_linux_arm64}\"" >&3
        echo "    end" >&3       
        echo "  end" >&3
        echo "" >&3
        echo "  def install" >&3
        echo "    bin.install Dir[\"bin/*\"].reject { |f|" >&3
        echo "      f.end_with?(\"/pact\", \"/pact-stub-server\", \"/pact_mock_server_cli\", \"/pact-plugin-cli\", \"/pact_verifier_cli\")" >&3
        echo "    }.to_a" >&3
        echo "    lib.install Dir[\"lib/*\"]" >&3
        echo "  end" >&3
        echo "" >&3
        echo "  test do" >&3
        echo "    system \"#{bin}/pact-broker\", \"help\"" >&3
        echo "    system \"#{bin}/pact-message\", \"help\"" >&3
        echo "    system \"#{bin}/pact-mock-service\", \"help\"" >&3
        echo "    system \"#{bin}/pact-provider-verifier\", \"help\"" >&3
        echo "    system \"#{bin}/pact-stub-service\", \"help\"" >&3
        echo "    system \"#{bin}/pactflow\", \"help\"" >&3
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

shas=()
for platform in osx linux; do 
    for arch in x86_64 arm64; do 
        filename=pact-$version-${platform}-${arch}
        echo "⬇️  Downloading $filename.tar.gz from $homepage"
        curl -LO $homepage/releases/download/v$version/$filename.tar.gz

        brewshasignature=( $(eval "openssl dgst -sha256 $filename.tar.gz") )
        echo "🔏 Checksum SHA256:\t ${brewshasignature[1]} for ${platform}-${arch}"

        shasignature=( $(eval "openssl dgst -sha1 $filename.tar.gz") )
        echo "🔏 Checksum SHA1:\t ${shasignature[1]} for ${platform}-${arch}"

        echo "⬇️  Downloading $filename.tar.gz.checksum for ${platform}-${arch}"
        curl -LO $homepage/releases/download/v$version/$filename.tar.gz.checksum

        expectedsha=( $(eval "cat $filename.tar.gz.checksum") )
        echo "🔏 Expected SHA1:\t ${expectedsha[0]} for ${platform}-${arch}"

        if [ "${shasignature[1]}" == "${expectedsha[0]}" ]; then
            echo "👮‍♀️ SHA Check: 👍 for ${platform}-${arch}"
        else
            echo "👮‍♀️ SHA Check: 🚨 - checksums do not match! for ${platform}-${arch}"
            exit 1
        fi

        echo "🧹 Cleaning up..."
        rm $filename.tar.gz
        rm $filename.tar.gz.checksum
        echo "🔏 Checksum SHA256:\t ${brewshasignature[1]} for ${platform}-${arch}"
        echo "🧪 Writing formulae..."
        shas+=(${brewshasignature[1]})
    done 
done 

    sha_osx_x86_64=${shas[0]}
    sha_osx_arm64=${shas[1]}
    sha_linux_x86_64=${shas[2]}
    sha_linux_arm64=${shas[3]}
    echo "sha_osx_x86_64:" $sha_osx_x86_64
    echo "sha_osx_arm64:" $sha_osx_arm64
    echo "sha_linux_x86_64:" $sha_linux_x86_64
    echo "sha_linux_arm64:" $sha_linux_arm64

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
