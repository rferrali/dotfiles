#!/bin/bash

#      ___        _                   __      _               
#     / __\__  __| | ___  _ __ __ _  / _\ ___| |_ _   _ _ __  
#    / _\/ _ \/ _` |/ _ \| '__/ _` | \ \ / _ \ __| | | | '_ \ 
#   / / |  __/ (_| | (_) | | | (_| | _\ \  __/ |_| |_| | |_) |
#   \/   \___|\__,_|\___/|_|  \__,_| \__/\___|\__|\__,_| .__/ 
#                                                      |_|    


echo "🦹 This script requires administrator privileges. Enter your password."
sudo -v
echo "🦹 You are now logged as root ✅"

# --- dnf Apps ---

echo "📦 Installing apps from dnf..."
# Enable repositories if they haven't been enabled
if ! dnf repolist | grep -q 'terra'; then
    echo "🌍 Enabling repository terra"
    sudo dnf install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
fi
if ! dnf repolist | grep -q 'gh-cli'; then
    echo "🌍 Enabling repository gh-cli"
    sudo dnf config-manager addrepo --from-repofile=https://cli.github.com/packages/rpm/gh-cli.repo
fi
if ! dnf repolist | grep -q 'docker-ce-stable'; then
    echo "🌍 Enabling repository docker-ce-stable"
    sudo dnf config-manager addrepo --from-repofile=https://download.docker.com/linux/fedora/docker-ce.repo
fi
if ! dnf repolist | grep -q 'vscode'; then
    echo "🌍 Enabling repository vscode"
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
fi

copr_repos=(
    el-file4138/zotero
    aquacash5/nerd-fonts
    mguessan/davmail
)

for repo in "${copr_repos[@]}"; do
    repo_name="${repo//\//:}"
    if ! dnf repolist | grep -q "copr:copr.fedorainfracloud.org:$repo_name"; then
        echo "🌍 Enabling repository $repo"
        sudo dnf copr enable -y "$repo"
    fi
done

dnf check-update

apps=(
    davmail
    docker-ce
    docker-ce-cli
    containerd.io
    docker-buildx-plugin
    code
    fastfetch
    fortune
    starship
    tldr
    zsh
    mozilla-fira-sans-fonts
    mozilla-fira-mono-fonts
    fira-code-nerd-fonts
    victor-mono-nerd-fonts
    python3-devel
    pipx
    zotero
    gnome-tweaks
    libappindicator-gtk3
    python3-gpg
    cabextract
    xorg-x11-font-utils
)

sudo dnf install -y "${apps[@]}"
sudo dnf install -y gh --repo gh-cli

# --- Microsoft fonts ---
if [ ! -d "/usr/share/fonts/msttcore" ]; then
    echo "🌍 Installing Microsoft fonts"
    sudo dnf install -y https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm
fi

# --- Flatpaks ---

echo "📦 Installing flatpaks..."
flatpaks=(
    md.obsidian.Obsidian
    com.spotify.Client
    com.surfshark.Surfshark
    org.inkscape.Inkscape
    com.mattjakeman.ExtensionManager
    sh.loft.devpod
    com.github.tchx84.Flatseal
    app.zen_browser.zen
    net.thunderbird.Thunderbird
)

flatpak install -y flathub "${flatpaks[@]}"

# --- Web Apps --- 

# Function to install an application by downloading if not already installed
install_web_app() {
    local app_name=$1
    local app_url=$2

    if ! command -v "$app_name" &> /dev/null
    then
        echo "📥 Installing... $app_name"
        curl -L -o /tmp/app.rpm "$app_url" && sudo dnf install -y /tmp/app.rpm
    else
        echo "✅ $app_name is already installed."
    fi
}

echo "🌐 Installing apps from the web..."

install_web_app "zoom" "https://zoom.us/client/latest/zoom_x86_64.rpm"
install_web_app "dropbox" "https://www.dropbox.com/download?dl=packages/fedora/nautilus-dropbox-2024.04.17-1.fc39.x86_64.rpm"

sudo dconf update

# --- pipx ---

echo "🐍 Installing pipx apps..."

# Function to install an application by downloading if not already installed
install_pipx() {
    local app=$1

    if ! command -v "$app" &> /dev/null
    then
        echo "📥 Installing... $app"
        pipx install "$app"
    else
        echo "✅ $app is already installed."
    fi
}

install_pipx cookiecutter

# --- Symlinks ---

# --- Oh My Zsh ---

echo "🛠️ Configuring Zsh..."
# detect if oh-my-zsh is installed
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "✅ Oh My Zsh is already installed."
else
    echo "🛠️ Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


# --- Zsh ---
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "🛠️ Setting Zsh as default shell..."
    chsh -s /usr/bin/zsh
else
    echo "✅ Zsh is already the default shell."
fi

echo "🛠️ Installing zsh plugins..."
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "✅ zsh-autosuggestions is already installed."
else
    echo "🛠️ Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
fi
if [ -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
    echo "✅ zsh-syntax-highlighting is already installed."
else
    echo "🛠️ Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
fi

# --- SSH ---
# echo "🔐 Configuring SSH..."
# mkdir -p $HOME/.ssh
# rm -f $HOME/.ssh/config
# ln -s $HOME/.dot-files/.ssh/config $HOME/.ssh/config
# chmod 600 $HOME/.ssh/config
# ln -s $HOME/.dot-files/.ssh/id_ed25519 $HOME/.ssh/id_ed25519
# ln -s $HOME/.dot-files/.ssh/id_ed25519.pub $HOME/.ssh/id_ed25519.pub

# --- Docker ---
# echo "🐳 Configuring Docker..."
# sudo groupadd docker
# sudo usermod -aG docker $USER
# sudo systemctl enable --now docker



echo "🎉 Installation complete!"