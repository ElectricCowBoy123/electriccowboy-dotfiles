#!/bin/bash

# ██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
# ██                                                                                                                      ██   
# ██   ███████ ██      ███████  ██████ ████████ ██████  ██  ██████  ██████  ██████  ██     ██ ██████   ██████  ██    ██   ██
# ██   ██      ██      ██      ██         ██    ██   ██ ██ ██      ██      ██    ██ ██     ██ ██   ██ ██    ██  ██  ██    ██
# ██   █████   ██      █████   ██         ██    ██████  ██ ██      ██      ██    ██ ██  █  ██ ██████  ██    ██   ████     ██
# ██   ██      ██      ██      ██         ██    ██   ██ ██ ██      ██      ██    ██ ██ ███ ██ ██   ██ ██    ██    ██      ██
# ██   ███████ ███████ ███████  ██████    ██    ██   ██ ██  ██████  ██████  ██████   ███ ███  ██████   ██████     ██      ██
# ██                                                                                                                      ██
# ██                                                                                                                      ██
# ██      ██████   ██████  ████████ ███████ ██ ██      ███████ ███████                                                    ██
# ██      ██   ██ ██    ██    ██    ██      ██ ██      ██      ██                                                         ██
# ██      ██   ██ ██    ██    ██    █████   ██ ██      █████   ███████                                                    ██
# ██      ██   ██ ██    ██    ██    ██      ██ ██      ██           ██                                                    ██
# ██   ██ ██████   ██████     ██    ██      ██ ███████ ███████ ███████                                                    ██
# ██                                                                                                                      ██
# ██████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████                                                                                                                


# ██    ██  █████  ██████  ██  █████  ██████  ██      ███████ ███████ 
# ██    ██ ██   ██ ██   ██ ██ ██   ██ ██   ██ ██      ██      ██      
# ██    ██ ███████ ██████  ██ ███████ ██████  ██      █████   ███████ 
#  ██  ██  ██   ██ ██   ██ ██ ██   ██ ██   ██ ██      ██           ██ 
#   ████   ██   ██ ██   ██ ██ ██   ██ ██████  ███████ ███████ ███████ 
                                                                                                 
export RESET="\033[0m";readonly RESET;
export BLUE="\033[1;34m";readonly BLUE;
export MAGENTA="\033[1;35m";readonly MAGENTA;
export CYAN="\033[1;36m";readonly CYAN;
export GREEN="\033[1;32m";readonly GREEN;
export RED="\033[1;31m";readonly RED;
export YELLOW="\033[1;33m";readonly YELLOW;
export ITALIC="\033[3m";readonly ITALIC;                                   

arrStr_required_packages=("jq" "sed")
readonly REPO_DIR="$(dirname "$(readlink -m "${0}")")"
readonly JSON_DIR="${REPO_DIR}/conf/install.json"
source "${REPO_DIR}/lib/core.sh"

#  █████  ██████   ██████  ██    ██ ███    ███ ███████ ███    ██ ████████     ██████   █████  ██████  ███████ ██ ███    ██  ██████  
# ██   ██ ██   ██ ██       ██    ██ ████  ████ ██      ████   ██    ██        ██   ██ ██   ██ ██   ██ ██      ██ ████   ██ ██       
# ███████ ██████  ██   ███ ██    ██ ██ ████ ██ █████   ██ ██  ██    ██        ██████  ███████ ██████  ███████ ██ ██ ██  ██ ██   ███ 
# ██   ██ ██   ██ ██    ██ ██    ██ ██  ██  ██ ██      ██  ██ ██    ██        ██      ██   ██ ██   ██      ██ ██ ██  ██ ██ ██    ██ 
# ██   ██ ██   ██  ██████   ██████  ██      ██ ███████ ██   ████    ██        ██      ██   ██ ██   ██ ███████ ██ ██   ████  ██████  
                                                                                       
if [ "$EUID" -ne 0 ]; then
  printf "${ITALIC}${RED}%s\n${RESET}" "[Error]: Please Run as Root!"
  exit 1
fi

if [ $# -eq 0 ]; then
    print_header
    printf "\n${ITALIC}${YELLOW}%s\n${RESET}" "No Arguments Supplied, Returning Help..."
    help
    exit 0
fi

# Parse Arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            print_header
            help
            exit 0
            ;;
        -i|--install)
        printf "${MAGENTA}%s\n${RESET}" "
██ ███    ██ ███████ ████████  █████  ██      ██      
██ ████   ██ ██         ██    ██   ██ ██      ██      
██ ██ ██  ██ ███████    ██    ███████ ██      ██      
██ ██  ██ ██      ██    ██    ██   ██ ██      ██      
██ ██   ████ ███████    ██    ██   ██ ███████ ███████ 
"
            # todo: implement subargments to install gaming packages etc
            check_required_packages "${arrStr_required_packages[@]}"
            check_package_managers
            parse_json
            install_packages "$str_packages"
            install_nvidia_drivers
            clean_up
            shift
            ;;
        -e|--extensions)
            printf "${MAGENTA}%s${RESET}" "
███████ ██   ██ ████████ ███████ ███    ██ ███████ ██  ██████  ███    ██ ███████ 
██       ██ ██     ██    ██      ████   ██ ██      ██ ██    ██ ████   ██ ██      
█████     ███      ██    █████   ██ ██  ██ ███████ ██ ██    ██ ██ ██  ██ ███████ 
██       ██ ██     ██    ██      ██  ██ ██      ██ ██ ██    ██ ██  ██ ██      ██ 
███████ ██   ██    ██    ███████ ██   ████ ███████ ██  ██████  ██   ████ ███████ 
" 
            # todo: implement subargments to install gaming packages etc
            printf "${ITALIC}${YELLOW}%s\n\n${RESET}" "you did e"
            clean_up
            shift
            ;;
        -g|--gits)
            printf "${MAGENTA}%s${RESET}" "
 ██████  ██ ████████ ███████ 
██       ██    ██    ██      
██   ███ ██    ██    ███████ 
██    ██ ██    ██         ██ 
 ██████  ██    ██    ███████ 
"
            parse_json
            handle_gits "${arrStr_gits[@]}"
            clean_up
            shift
            ;;
        -s|--settings)
            printf "${MAGENTA}%s${RESET}" "
███████ ███████ ████████ ████████ ██ ███    ██  ██████  ███████ 
██      ██         ██       ██    ██ ████   ██ ██       ██      
███████ █████      ██       ██    ██ ██ ██  ██ ██   ███ ███████ 
     ██ ██         ██       ██    ██ ██  ██ ██ ██    ██      ██ 
███████ ███████    ██       ██    ██ ██   ████  ██████  ███████ 
"
            #apply_settings
            clean_up
            shift
            ;;
        -f|--flatpaks)
            printf "${MAGENTA}%s${RESET}" "
███████ ██       █████  ████████ ██████   █████  ██   ██ ███████ 
██      ██      ██   ██    ██    ██   ██ ██   ██ ██  ██  ██      
█████   ██      ███████    ██    ██████  ███████ █████   ███████ 
██      ██      ██   ██    ██    ██      ██   ██ ██  ██       ██ 
██      ███████ ██   ██    ██    ██      ██   ██ ██   ██ ███████ 
"
            arrStr_required_packages+=("flatpak")
            check_required_packages "${arrStr_required_packages[@]}"
            parse_json
            install_flatpaks "${arrStr_flatpaks[@]}"
            clean_up
            shift
            ;;
        -d|--desktop)
            printf "${MAGENTA}%s${RESET}" "
██████  ███████ ███████ ██   ██ ████████  ██████  ██████  
██   ██ ██      ██      ██  ██     ██    ██    ██ ██   ██ 
██   ██ █████   ███████ █████      ██    ██    ██ ██████  
██   ██ ██           ██ ██  ██     ██    ██    ██ ██      
██████  ███████ ███████ ██   ██    ██     ██████  ██      
"
            check_package_managers
            parse_json
            detect_desktop_environment
            install_desktop_environment
            clean_up
            shift
            ;;
        --info)
            printf "${MAGENTA}%s${RESET}" "
██ ███    ██ ███████  ██████  
██ ████   ██ ██      ██    ██ 
██ ██ ██  ██ █████   ██    ██ 
██ ██  ██ ██ ██      ██    ██ 
██ ██   ████ ██       ██████  
"
            system_information
            clean_up
            shift
            ;;
        *)
            printf "${ITALIC}${RED}%s\n${RESET}" "[Error]: Unknown argument! '$1'"
            clean_up
            exit 0
            ;;
    esac
done
