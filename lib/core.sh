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
    help_entry "-d, --desktop" "TODO: Install a Desktop Environment Defined in the JSON File."
}

help_entry() {
  printf "${BLUE}%s ${ITALIC}${CYAN}%s${MAGENTA}%s ${GREEN}%s\n${RESET}" "${1}" "${2}" "${3}" "${4}"
}

check_package_managers() {
    # Ensure these are organized in order of importance as first item in array will be primary method of installing packages for the run
    arrStr_pacman=()
    
    if command -v dnf &> /dev/null; then
        arrStr_pacman+=("dnf")
    fi

    if command -v yum &> /dev/null; then
        arrStr_pacman+=("yum")
    fi

    if command -v apt &> /dev/null; then
        arrStr_pacman+=("apt")
    fi

    if command -v apt-get &> /dev/null; then
        arrStr_pacman+=("apt-get")
    fi

    if command -v pacman &> /dev/null; then
        arrStr_pacman+=("pacman")
    fi

    if command -v zypper &> /dev/null; then
        arrStr_pacman+=("zypper")
    fi

    if command -v rpm &> /dev/null; then
        arrStr_pacman+=("rpm")
    fi

    if command -v dpkg &> /dev/null; then
        arrStr_pacman+=("dpkg")
    fi

    if command -v snap &> /dev/null; then
        arrStr_pacman+=("snap")
    fi

    if command -v emerge &> /dev/null; then
        arrStr_pacman+=("portage")
    fi

    if command -v flatpak &> /dev/null; then
        arrStr_pacman+=("flatpak")
    fi

    if [ ${#arrStr_pacman[@]} -eq 0 ]; then
        arrStr_pacman+=("error")
    fi
}

check_required_packages(){
    if [[ $# -eq 0 ]]; then
        printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: No arguments supplied in check_required_packages function!"
        return 1
    fi

    local str_packages=("$@")
    
    for str_package in "${str_packages[@]}"; do
        if [[ ! -n $(command -v "$str_package") ]]; then
            printf "${RED}%s is not Installed.\n\n${RESET}" "$str_package"
            exit 1
        fi
    done
}

validate_json(){
    #TODO
    echo "awdawd"
}

parse_json(){
    while IFS= read -r str_line; do
        arrStr_gits+=("$str_line")
    done < <(jq -r ".git[] | .[]?" "$JSON_DIR")

    while IFS= read -r str_line; do
        arrStr_flatpaks+=("$str_line")
    done < <(jq -r ".flatpaks[]" "$JSON_DIR")

    str_nvidia_drivers=$(jq -r '.["nvidia-drivers"]' "$JSON_DIR")

    str_update_os=$(jq -r '.["update-os"]' "$JSON_DIR")

    if [[ ${arrStr_pacman[0]} == "dnf" ]]; then
        str_packages=""
        str_elements=$(jq -r ".packages.${arrStr_pacman[0]}[] | .[]" "$JSON_DIR")
        while IFS= read -r str_element; do
            str_packages+="$str_element "
        done <<< "$str_elements"
    fi

    if [[ ${arrStr_pacman[0]} == "apt-get" ]]; then
        str_packages=""
        str_elements=$(jq -r ".packages.${arrStr_pacman[0]}[] | .[]" "$JSON_DIR")
        while IFS= read -r str_element; do
            str_packages+="$str_element "
        done <<< "$str_elements"
    fi

    if [[ ${arrStr_pacman[0]} == "apt" ]]; then
        str_packages=""
        str_elements=$(jq -r ".packages.${arrStr_pacman[0]}[] | .[]" "$JSON_DIR")
        while IFS= read -r str_element; do
            str_packages+="$str_element "
        done <<< "$str_elements"
    fi
}

clean_up(){
    if [[ ${arrStr_pacman[0]} == "dnf" ]]; then
        printf "\n${GREEN}%s\n${RESET}\n" "Clearing dnf Cache..."
        dnf clean all || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to Clean up dnf Cache! '$1'"; exit 1; }
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
        printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: No arguments supplied in install_package function!"
        return 1
    fi

    for str_element in "${arrStr_pacman[@]}"; do
        if [[ $str_element == "error" ]]; then
            printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: No recognized package managers were found on your system, unable to execute script!"
            return 1
        fi
    done

    if [ $# -eq 0 ] || [ -z "$1" ]; then
        printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: No packages supplied!"
        return 1
    fi

    if [[ ${arrStr_pacman[0]} == "dnf" ]]; then
        printf "${GREEN}%s\n${RESET}\n" "Updating Package Repositories..."
        dnf update --refresh -y || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to dnf update!"; exit 1; }

        printf "\n${GREEN}%s\n${RESET}\n" "Installing Package(s) '$1'..."
        dnf install -y ${1} || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to Install Package(s)! '$1'"; exit 1; }

        if [[ $str_update_os == "true" ]]; then
            printf "\n${GREEN}%s\n${RESET}\n" "Performing OS Update (Upgrade)..."
            dnf upgrade --refresh -y || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to dnf upgrade!"; exit 1; }
        fi

        return 0
    fi

    if [[ ${arrStr_pacman[0]} == "apt" ]]; then
        printf "${GREEN}%s\n${RESET}\n" "Updating Package Repositories..."
        apt update || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to apt update!"; exit 1; }

        printf "\n${GREEN}%s\n${RESET}\n" "Installing Package(s) '$1'..."
        apt install "${1}" || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to Install Package(s)! '$1'"; exit 1; }

        if [[ $str_update_os == "true" ]]; then
            printf "\n${GREEN}%s\n${RESET}\n" "Performing OS Update (Upgrade)..."
            apt upgrade -y || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to apt upgrade!"; exit 1; }
        fi

        return 0
    fi

    if [[ ${arrStr_pacman[0]} == "apt-get" ]]; then
        printf "${GREEN}%s\n${RESET}\n" "Updating Package Repositories..."
        apt-get update || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to apt-get update!"; exit 1; }

        printf "\n${GREEN}%s\n${RESET}\n" "Installing Package(s) '$1'..."
        apt-get install "${1}" || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to Install Package(s)! '$1'"; exit 1; }

        if [[ $str_update_os == "true" ]]; then
            printf "\n${GREEN}%s\n${RESET}\n" "Performing OS Update (Upgrade)..."
            apt-get upgrade -y || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to apt-get upgrade!"; exit 1; }
        fi

        return 0
    fi
}

handle_gits(){
    if [[ $# -eq 0 ]]; then
        printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: No arguments supplied in handle_gits function!"
        return 1
    fi

    if [ $# -eq 0 ] || [ -z "$1" ]; then
        printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: No gits supplied!"
        return 1
    fi

    for str_git in "${arrStr_gits[@]}"; do
        if [[ $str_git == https://* && $str_git == *.git ]]; then
            if [[ $str_git == "https://github.com/vinceliuice/WhiteSur-gtk-theme.git" ]]; then
                if [[ ! -d "/home/$SUDO_USER/.themes/WhiteSur-Dark" && ! -d "/home/$SUDO_USER/.themes/WhiteSur-Light" ]]; then
                    printf  "\n${GREEN}%s\n${RESET}\n" "Installing 'WhiteSur-gtk-theme'..."
                    git clone --depth=1 "$str_git" "/home/$SUDO_USER/Downloads/WhiteSur-gtk-theme"
                    chmod +x "/home/$SUDO_USER/Downloads/WhiteSur-gtk-theme/install.sh"
                else
                    printf "\n${GREEN}%s\n${RESET}\n" "'WhiteSur-gtk-theme' Already Installed."
                fi
            elif [[ $str_git == "https://github.com/ohmyzsh/ohmyzsh.git" ]]; then
                if [[ ! -d "/home/$SUDO_USER/.oh-my-zsh" ]]; then
                    printf  "\n${GREEN}%s\n${RESET}\n" "Installing 'ohmyzsh'..."
                    git clone "$str_git" "/home/$SUDO_USER/Downloads/ohmyzsh"
                    chmod +x "/home/$SUDO_USER/Downloads/ohmyzsh/tools/install.sh"
                    sh "/home/$SUDO_USER/Downloads/ohmyzsh/tools/install.sh" || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Error occurred installing 'ohmyzsh'! '$1'"; exit 1; }
                else
                    printf "\n${GREEN}%s\n${RESET}\n" "'ohmyzsh' Already Installed."
                fi
            elif [[ $str_git == "https://github.com/romkatv/powerlevel10k.git" ]]; then
                if [[ ! $(grep -Fxq "source /home/$SUDO_USER/.powerlevel10k/powerlevel10k.zsh-theme" /home/$SUDO_USER/.zshrc; echo $?) -ne 0 ]]; then
                    printf "\n${GREEN}%s\n${RESET}\n" "Installing 'powerlevel10k' Recommended Font..."
                    curl -L -o "/home/$SUDO_USER/Downloads/MesloLGS_NF_Regular.ttf" 'https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf'
                    mv "/home/$SUDO_USER/Downloads/MesloLGS_NF_Regular.ttf" "/home/$SUDO_USER/.local/share/fonts/"
                    fc-cache -fv
                    printf "\n${GREEN}%s\n${RESET}\n" "Installing 'powerlevel10k'..."
                    git clone --depth=1 "$str_git" "/home/$SUDO_USER/.powerlevel10k"
                    echo 'source /home/$SUDO_USER/.powerlevel10k/powerlevel10k.zsh-theme' >>/home/$SUDO_USER/.zshrc
                else
                    printf "\n${GREEN}%s\n${RESET}\n" "'powerlevel10k' Already Installed."
                fi
            elif [[ $str_git == "https://github.com/vinceliuice/McMojave-circle.git" ]]; then
                if [[ ! -d "/home/$SUDO_USER/.local/share/icons/McMojave-circle" && ! -d "/home/$SUDO_USER/.local/share/icons/McMojave-circle-dark" && ! -d "/home/$SUDO_USER/.local/share/icons/McMojave-circle-light" ]]; then
                    printf "\n${GREEN}%s\n${RESET}\n" "Installing 'McMojave-circle'..."
                    git clone "$str_git" "/home/$SUDO_USER/Downloads/McMojave-circle"
                    chmod +x "/home/$SUDO_USER/Downloads/McMojave-circle/install.sh"
                    sh "/home/$SUDO_USER/Downloads/McMojave-circle/install.sh" || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Error occurred installing 'McMojave-circle'! '$1'"; exit 1; }
                else
                    printf "\n${GREEN}%s\n${RESET}\n" "'McMojave-circle' Already Installed."
                fi
            else
                repo_name=$(echo "$str_git" | sed -e 's/.*\/\(.*\)\.git/\1/')
                if [[ ! -d "/home/$SUDO_USER/Downloads/$repo_name" ]]; then
                    printf "\n${GREEN}%s\n${RESET}\n" "Installing '$repo_name'"
                    git clone "$str_git" "/home/$SUDO_USER/Downloads/$repo_name"
                    chmod +x "/home/$SUDO_USER/Downloads/$repo_name/install.sh"
                    sh "/home/$SUDO_USER/Downloads/$repo_name/install.sh" || { printf "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Error occurred installing '$repo_name'! '$str_git'"; exit 1; }
                else
                    printf "\n${GREEN}%s\n${RESET}\n" "'$repo_name' Already Installed."
                fi
            fi
        else
            printf "\n${RED}%s\n${RESET}\n" "'$str_git' is Not a Valid Repo!"
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
    printf "\n${GREEN}%s\n${RESET}\n" "Installing Flatpaks..."
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo || { "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to Add Flathub Repo to Flatpak!"; exit 1;}
    for str_flatpak in "${arrStr_flatpaks[@]}"; do
        flatpak install -y flathub $str_flatpak
    done
}

install_nvidia_drivers(){
    if command -v nvidia-smi &> /dev/null; then
        printf "\n${GREEN}%s\n${RESET}\n" "Nvidia Drivers are Already Installed, Skipping."
        return 1
    fi
    
    if [[ $str_nvidia_drivers == "true" ]]; then
        if lspci | grep -i nvidia &> /dev/null; then
            printf "\n${GREEN}%s\n${RESET}\n" "Installing Nvidia Drivers..."
            if [[ ${arrStr_pacman[0]} == "dnf" ]]; then
                dnf install -y kernel-devel kernel-headers gcc make dkms acpid libglvnd-opengl libglvnd-devel pkgconfig
                dnf install -y "https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm"
                dnf install -y "https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm"
                dnf makecache || { "${ITALIC}${RED}%s\n${RESET}\n" "[Error]: Failed to Update the dnf Metadata Cache!"; exit 1;}
                dnf install -y akmod-nvidia xorg-x11-drv-nvidia-cuda
            fi
        fi
    fi
}

recommended_kde_config(){
    echo "TODO"
}

configure_desktop_environment(){
    # Check if desktop environment currently exists
    # Check specified desktop environment
    # Install it and required dependencies
    # Detect the login manager if there is one, if not install gdm
    # Set the desktop environment to automatically start in gdm upon login
    
}