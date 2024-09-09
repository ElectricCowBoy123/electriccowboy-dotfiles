#!/bin/bash

# ███    ███ ██ ███████  ██████     ███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████ 
# ████  ████ ██ ██      ██          ██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██      
# ██ ████ ██ ██ ███████ ██          █████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████ 
# ██  ██  ██ ██      ██ ██          ██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██ 
# ██      ██ ██ ███████  ██████     ██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████ 
                                                                                                                                                                                                        
help(){
    help_entry "-h, --help" "Returns this Dialogue."
    help_entry "-i, --install" "Installs Software Defined in the JSON File, Nvidia Drivers if they're Needed & Updates all Packages."
    help_entry "-g, --gits" "Clones the Git Repositories Defined in the JSON File."
    help_entry "-s, --settings" "Applies Configuration Tweaks Defined in the JSON File."
    help_entry "-f, --flatpaks" "Installs Flatpaks Defined in the JSON File."
}

help_entry() {
  printf "${c_blue}%s ${c_italic}${c_cyan}%s${c_magenta}%s ${c_green}%s\n${c_reset}" "${1}" "${2}" "${3}" "${4}"
}

check_package_managers() {
    # Ensure these are organized in order of importance as first item in array will be primary method of installing packages for the run
    pacman=()
    
    if command -v dnf &> /dev/null; then
        pacman+=("dnf")
    fi

    if command -v yum &> /dev/null; then
        pacman+=("yum")
    fi

    if command -v apt &> /dev/null; then
        pacman+=("apt")
    fi

    if command -v apt-get &> /dev/null; then
        pacman+=("apt-get")
    fi

    if command -v pacman &> /dev/null; then
        pacman+=("pacman")
    fi

    if command -v zypper &> /dev/null; then
        pacman+=("zypper")
    fi

    if command -v rpm &> /dev/null; then
        pacman+=("rpm")
    fi

    if command -v dpkg &> /dev/null; then
        pacman+=("dpkg")
    fi

    if command -v snap &> /dev/null; then
        pacman+=("snap")
    fi

    if command -v emerge &> /dev/null; then
        pacman+=("portage")
    fi

    if command -v flatpak &> /dev/null; then
        pacman+=("flatpak")
    fi

    if [ ${#pacman[@]} -eq 0 ]; then
        pacman+=("error")
    fi
}

check_required_packages(){
    if [[ $# -eq 0 ]]; then
        printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: No arguments supplied in check_required_packages function!"
        return 1
    fi

    local packages=("$@")
    
    for package in "${packages[@]}"; do
        if [[ ! -n $(command -v "$package") ]]; then
            printf "${c_red}%s is not Installed.\n\n${c_reset}" "$package"
            exit 1
        fi
    done
}

parse_json(){
    while IFS= read -r line; do
        gits+=("$line")
    done < <(jq -r ".git[]" "$JSON_DIR")

    while IFS= read -r line; do
        flatpaks+=("$line")
    done < <(jq -r ".flatpaks[]" "$JSON_DIR")

    nvidia_drivers=$(jq -r '.["nvidia-drivers"]' "$JSON_DIR")

    if [[ ${pacman[0]} == "dnf" ]]; then
        packages=""
        elements=$(jq -r ".packages.${pacman[0]}[] | .[]" "$JSON_DIR")
        while IFS= read -r element; do
            packages+="$element "
        done <<< "$elements"
    fi

    if [[ ${pacman[0]} == "apt-get" ]]; then
        packages=""
        elements=$(jq -r ".packages.${pacman[0]}[] | .[]" "$JSON_DIR")
        while IFS= read -r element; do
            packages+="$element "
        done <<< "$elements"
    fi

    if [[ ${pacman[0]} == "apt" ]]; then
        packages=""
        elements=$(jq -r ".packages.${pacman[0]}[] | .[]" "$JSON_DIR")
        while IFS= read -r element; do
            packages+="$element "
        done <<< "$elements"
    fi
}

clean_up(){
    if [[ ${pacman[0]} == "dnf" ]]; then
        printf "\n${c_green}%s\n${c_reset}\n" "Clearing dnf Cache..."
        dnf clean all || { printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: Failed to Clean up dnf Cache! '$1'"; exit 1; }
        exit 0
    fi
}

# ███    ███  █████  ██ ███    ██     ███████ ██    ██ ███    ██  ██████ ████████ ██  ██████  ███    ██ ███████ 
# ████  ████ ██   ██ ██ ████   ██     ██      ██    ██ ████   ██ ██         ██    ██ ██    ██ ████   ██ ██      
# ██ ████ ██ ███████ ██ ██ ██  ██     █████   ██    ██ ██ ██  ██ ██         ██    ██ ██    ██ ██ ██  ██ ███████ 
# ██  ██  ██ ██   ██ ██ ██  ██ ██     ██      ██    ██ ██  ██ ██ ██         ██    ██ ██    ██ ██  ██ ██      ██ 
# ██      ██ ██   ██ ██ ██   ████     ██       ██████  ██   ████  ██████    ██    ██  ██████  ██   ████ ███████ 
                                                                                                                                                                                                                                                                                                                                                     
install_packages(){
    if [[ $# -eq 0 ]]; then
        printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: No arguments supplied in install_package function!"
        return 1
    fi

    for element in "${pacman[@]}"; do
        if [[ $element == "error" ]]; then
            printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: No recognized package managers were found on your system, unable to execute script!"
            return 1
        fi
    done

    if [ $# -eq 0 ] || [ -z "$1" ]; then
        printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: No packages supplied!"
        return 1
    fi

    if [[ ${pacman[0]} == "dnf" ]]; then
        printf "${c_green}%s\n${c_reset}\n" "Updating Package Repositories..."
        dnf update --refresh -y || { printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: Failed to dnf update!"; exit 1; }

        printf "\n${c_green}%s\n${c_reset}\n" "Installing Package(s) '$1'..."
        dnf install -y ${1} || { printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: Failed to Install Package(s)! '$1'"; exit 1; }

        return 0
    fi

    if [[ ${pacman[0]} == "apt" ]]; then
        printf "${c_green}%s\n${c_reset}\n" "Updating Package Repositories..."
        apt update || { printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: Failed to apt update!"; exit 1; }

        printf "\n${c_green}%s\n${c_reset}\n" "Installing Package(s) '$1'..."
        apt install "${1}" || { printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: Failed to Install Package(s)! '$1'"; exit 1; }
        return 0
    fi

    if [[ ${pacman[0]} == "apt-get" ]]; then
        printf "${c_green}%s\n${c_reset}\n" "Updating Package Repositories..."
        apt-get update || { printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: Failed to apt-get update!"; exit 1; }

        printf "\n${c_green}%s\n${c_reset}\n" "Installing Package(s) '$1'..."
        apt-get install "${1}" || { printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: Failed to Install Package(s)! '$1'"; exit 1; }
        return 0
    fi
}

handle_gits(){
    if [[ $# -eq 0 ]]; then
        printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: No arguments supplied in handle_gits function!"
        return 1
    fi

    if [ $# -eq 0 ] || [ -z "$1" ]; then
        printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: No gits supplied!"
        return 1
    fi

    for git in "${gits[@]}"; do

        if [[ $git == "https://github.com/vinceliuice/WhiteSur-gtk-theme.git" ]]; then
            if [[ -f "/home/$SUDO_USER/.themes/WhiteSur-Dark" && -f "/home/$SUDO_USER/.themes/WhiteSur-Light" ]]; then
                printf  "\n${c_green}%s\n${c_reset}\n" "Installing 'WhiteSur-gtk-theme'..."
                git clone --depth=1 "$git" "/home/$SUDO_USER/Downloads/WhiteSur-gtk-theme"
                chmod +x "/home/$SUDO_USER/Downloads/WhiteSur-gtk-theme/install.sh"
            else
                printf "\n${c_green}%s\n${c_reset}\n" "'WhiteSur-gtk-theme' Already Installed."
            fi
        fi

        if [[ $git == "https://github.com/ohmyzsh/ohmyzsh.git" ]]; then
            if [[ -f "/home/$SUDO_USER/.oh-my-zsh" ]]; then
                printf  "\n${c_green}%s\n${c_reset}\n" "Installing 'ohmyzsh'..."
                git clone "$git" "/home/$SUDO_USER/Downloads/ohmyzsh"
                chmod +x "/home/$SUDO_USER/Downloads/ohmyzsh/tools/install.sh"
                sh "/home/$SUDO_USER/Downloads/ohmyzsh/tools/install.sh" || { printf "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: Error occurred installing 'ohmyzsh'! '$1'"; exit 1; }
            else
                printf "\n${c_green}%s\n${c_reset}\n" "'ohmyzsh' Already Installed."
            fi
        fi

        if [[ $git == "https://github.com/romkatv/powerlevel10k.git" ]]; then
            if [[ ! $(grep -Fxq "source /home/$SUDO_USER/.powerlevel10k/powerlevel10k.zsh-theme" /home/$SUDO_USER/.zshrc; echo $?) -ne 0 ]]; then
                printf "\n${c_green}%s\n${c_reset}\n" "Installing 'powerlevel10k' Recommended Font..."
                curl -L -o "/home/$SUDO_USER/Downloads/MesloLGS_NF_Regular.ttf" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf'
                mv "/home/$SUDO_USER/Downloads/MesloLGS_NF_Regular.ttf" "/home/$SUDO_USER/.local/share/fonts/"
                fc-cache -fv

                printf "\n${c_green}%s\n${c_reset}\n" "Installing 'powerlevel10k'..."
                git clone --depth=1 "https://github.com/romkatv/powerlevel10k.git" "/home/$SUDO_USER/.powerlevel10k"
                echo 'source /home/$SUDO_USER/.powerlevel10k/powerlevel10k.zsh-theme' >>/home/$SUDO_USER/.zshrc
            else
                printf "\n${c_green}%s\n${c_reset}\n" "'powerlevel10k' Already Installed."
            fi
        fi
        
        if [[ $git == "https://github.com/vinceliuice/McMojave-circle.git" ]]; then
            if [[ -f "/home/$SUDO_USER/.local/share/icons/McMojave-circle" && -f "/home/$SUDO_USER/.local/share/icons/McMojave-circle-dark" && -f "/home/$SUDO_USER/.local/share/icons/McMojave-circle-light" ]]; then
                printf "\n${c_green}%s\n${c_reset}\n" "Installing 'McMojave-circle'..."
                git clone "$git" "/home/$SUDO_USER/Downloads/McMojave-circle"
                # TODO
            else
                printf "\n${c_green}%s\n${c_reset}\n" "'McMojave-circle' Already Installed."
            fi
        fi
    done
}

apply_settings(){
    if [[ "$XDG_CURRENT_DESKTOP" == "GNOME" ]]; then
        echo "This is GNOME" 
        # TODO
    fi
}

install_flatpaks(){
    printf "\n${c_green}%s\n${c_reset}\n" "Installing Flatpaks..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || { "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: Failed to Add Flathub Repo to Flatpak!"; exit 1;}
    for flatpak in "${flatpaks[@]}"; do
        flatpak install -y flathub $flatpak
    done
}

install_nvidia_drivers(){
    if command -v nvidia-smi &> /dev/null; then
        printf "\n${c_green}%s\n${c_reset}\n" "Nvidia Drivers are Already Installed, Skipping."
        return 1
    fi
    
    if [[ $nvidia_drivers == "true" ]]; then
        if lspci | grep -i nvidia &> /dev/null; then
            printf "\n${c_green}%s\n${c_reset}\n" "Installing Nvidia Drivers..."
            if [[ ${pacman[0]} == "dnf" ]]; then
                dnf install -y kernel-devel kernel-headers gcc make dkms acpid libglvnd-opengl libglvnd-devel pkgconfig
                dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
                dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
                dnf makecache || { "${c_italic}${c_red}%s\n${c_reset}\n" "[Error]: Failed to Update the dnf Metadata Cache!"; exit 1;}
                dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
            fi
        fi
    fi
}
