#!/bin/bash

▗▄▄▄▖▗▖   ▗▄▄▄▖ ▗▄▄▖▗▄▄▄▖▗▄▄▖ ▗▄▄▄▖ ▗▄▄▖ ▗▄▄▖ ▗▄▖ ▗▖ ▗▖▗▄▄▖  ▗▄▖▗▖  ▗▖
▐▌   ▐▌   ▐▌   ▐▌     █  ▐▌ ▐▌  █  ▐▌   ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▝▚▞▘ 
▐▛▀▀▘▐▌   ▐▛▀▀▘▐▌     █  ▐▛▀▚▖  █  ▐▌   ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▛▀▚▖▐▌ ▐▌ ▐▌  
▐▙▄▄▖▐▙▄▄▖▐▙▄▄▖▝▚▄▄▖  █  ▐▌ ▐▌▗▄█▄▖▝▚▄▄▖▝▚▄▄▖▝▚▄▞▘▐▙█▟▌▐▙▄▞▘▝▚▄▞▘ ▐▌  
▗▄▄▄  ▗▄▖▗▄▄▄▖▗▄▄▄▖▗▄▄▄▖▗▖   ▗▄▄▄▖ ▗▄▄▖
▐▌  █▐▌ ▐▌ █  ▐▌     █  ▐▌   ▐▌   ▐▌   
▐▌  █▐▌ ▐▌ █  ▐▛▀▀▘  █  ▐▌   ▐▛▀▀▘ ▝▀▚▖
▐▙▄▄▀▝▚▄▞▘ █  ▐▌   ▗▄█▄▖▐▙▄▄▖▐▙▄▄▖▗▄▄▞▘
# https://patorjk.com/software/taag/#p=display&f=RubiFont&t=dotfiles                   

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root!"
  exit
fi

readonly REPO_DIR="$(dirname "$(readlink -m "${0}")")"


#echo "Running in Fedora mode"
#dnf update --refresh || echo "[Error] Failed to dnf update!" && exit 1
#dnf install -y gnome-tweaks gnome-extensions-app git flatpak || exit 1

#dnf install -y kernel-devel kernel-headers gcc make dkms acpid libglvnd-glx libglvnd-opengl libglvnd-devel pkgconfig || exit 1

#dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm || exit 1
#dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm || exit 1

#dnf makecache || exit 1
#dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda || exit 1

# Install Oh My Zsh
#curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o ~/Downloads/install-ohmyzsh.sh || exit 1

# Make the script executable
#chmod +x ~/Downloads/install-ohmyzsh.sh || exit 1

# Execute the script
#sh ~/Downloads/install-ohmyzsh.sh || exit 1

# Set up Powerlevel10k theme
#git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/Downloads/powerlevel10k || exit 1
#echo 'source ~/Downloads/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc || exit 1

# Add Flathub repository and install flatpak apps
#flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || exit 1
#flatpak install -y flathub net.lutris.Lutris com.github.tchx84.Flatseal io.missioncenter.MissionCenter com.github.Matoking.protontricks net.davidotek.pupgui2 || exit 1

# Install WhiteSur GTK theme
git clone --depth=1 https://github.com/vinceliuice/WhiteSur-gtk-theme.git ~/Downloads/WhiteSur-gtk-theme || exit 1
~/Downloads/WhiteSur-gtk-theme/install.sh -c Dark || exit 1

# Clean up
#dnf clean all || exit 1

echo "Setup complete. It is recommended to reboot the system."

# Install McMojave-circle
#git clone --depth=1  https://github.com/vinceliuice/McMojave-circle.git ~/Downloads/McMojave-circle || exit 1
#~/Downloads/McMojave-circle/install.sh || exit 1
