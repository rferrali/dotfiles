#!/bin/sh

case "$(uname -s)" in
Darwin)
    BW="bw"
    ;;
Linux)
    BW="flatpak run --command=bw com.bitwarden.desktop"
    ;;
*)
    echo "unsupported OS"
    exit 1
    ;;
esac

case "$(uname -s)" in
Darwin)
    # commands to install password-manager-binary on Darwin
    if test ! $(which brew) 
    then
        echo "🍺 Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/$user/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    if ! command -v gpg >/dev/null 2>&1; then
        echo "🔐 Installing gnupg..."
        brew install gnupg
    fi
    if ! command -v bw >/dev/null 2>&1; then
        echo "🔐 Installing bitwarden-cli..."
        brew install bitwarden-cli
    fi
    ;;
Linux)
    if ! flatpak list --app | grep -q com.bitwarden.desktop; then
        flatpak install flathub com.bitwarden.desktop -y
    fi
    ;;
esac

if [ "$($BW config server 2>/dev/null)" != "https://vault.bitwarden.eu" ]; then
    $BW config server https://vault.bitwarden.eu
fi
if ! gpg --list-secret-keys "rferrali@gmail.com" >/dev/null 2>&1; then
    if [ -z "$BW_SESSION" ]; then
        echo "🚨 Variable BW_SESSION is not defined. Make sure you are logged into Bitwarden and try again."
        echo "- To login: $BW login"
        echo "- To get a session token: $BW unlock"
        echo "Then follow the instructions and re-run this command"
        exit 1
    fi
    # get the gpg keys from bitwarden
    $BW get notes privatekey.asc | gpg --pinentry-mode loopback --import
    $BW get notes publickey.asc | gpg --import
fi