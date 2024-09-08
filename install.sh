#!/bin/bash

##########################################################################
# ▗▄▄▄▖▗▖   ▗▄▄▄▖ ▗▄▄▖▗▄▄▄▖▗▄▄▖ ▗▄▄▄▖ ▗▄▄▖ ▗▄▄▖ ▗▄▖ ▗▖ ▗▖▗▄▄▖  ▗▄▖▗▖  ▗▖ #
# ▐▌   ▐▌   ▐▌   ▐▌     █  ▐▌ ▐▌  █  ▐▌   ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▝▚▞▘  #
# ▐▛▀▀▘▐▌   ▐▛▀▀▘▐▌     █  ▐▛▀▚▖  █  ▐▌   ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▛▀▚▖▐▌ ▐▌ ▐▌   #
# ▐▙▄▄▖▐▙▄▄▖▐▙▄▄▖▝▚▄▄▖  █  ▐▌ ▐▌▗▄█▄▖▝▚▄▄▖▝▚▄▄▖▝▚▄▞▘▐▙█▟▌▐▙▄▞▘▝▚▄▞▘ ▐▌   #
#                                                                        #
#    ▗▄▄▄  ▗▄▖▗▄▄▄▖▗▄▄▄▖▗▄▄▄▖▗▖   ▗▄▄▄▖ ▗▄▄▖                             #
#    ▐▌  █▐▌ ▐▌ █  ▐▌     █  ▐▌   ▐▌   ▐▌                                #
#    ▐▌  █▐▌ ▐▌ █  ▐▛▀▀▘  █  ▐▌   ▐▛▀▀▘ ▝▀▚▖                             #
#  ▄ ▐▙▄▄▀▝▚▄▞▘ █  ▐▌   ▗▄█▄▖▐▙▄▄▖▐▙▄▄▖▗▄▄▞▘                             #
##########################################################################

##################################################
# ▗▖  ▗▖ ▗▄▖ ▗▄▄▖ ▗▄▄▄▖ ▗▄▖ ▗▄▄▖ ▗▖   ▗▄▄▄▖ ▗▄▄▖ #
# ▐▌  ▐▌▐▌ ▐▌▐▌ ▐▌  █  ▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌   ▐▌    #
# ▐▌  ▐▌▐▛▀▜▌▐▛▀▚▖  █  ▐▛▀▜▌▐▛▀▚▖▐▌   ▐▛▀▀▘ ▝▀▚▖ #
#  ▝▚▞▘ ▐▌ ▐▌▐▌ ▐▌▗▄█▄▖▐▌ ▐▌▐▙▄▞▘▐▙▄▄▖▐▙▄▄▖▗▄▄▞▘ #
##################################################                                             

export c_reset="\033[0m"
export c_blue="\033[1;34m"
export c_magenta="\033[1;35m"
export c_cyan="\033[1;36m"
export c_green="\033[1;32m"
export c_red="\033[1;31m"
export c_yellow="\033[1;33m"   
export c_italic='\033[3m'                                         

required_packages=("jq" "sed")
readonly REPO_DIR="$(dirname "$(readlink -m "${0}")")"
readonly JSON_DIR="${REPO_DIR}/conf/install.json"
source "${REPO_DIR}/lib/core.sh"

######################################################################################
#  ▗▄▖ ▗▄▄▖  ▗▄▄▖▗▖ ▗▖▗▖  ▗▖▗▄▄▄▖▗▖  ▗▖▗▄▄▄▖    ▗▄▄▖  ▗▄▖ ▗▄▄▖  ▗▄▄▖▗▄▄▄▖▗▖  ▗▖ ▗▄▄▖ #
# ▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌ ▐▌▐▛▚▞▜▌▐▌   ▐▛▚▖▐▌  █      ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌     █  ▐▛▚▖▐▌▐▌    #
# ▐▛▀▜▌▐▛▀▚▖▐▌▝▜▌▐▌ ▐▌▐▌  ▐▌▐▛▀▀▘▐▌ ▝▜▌  █      ▐▛▀▘ ▐▛▀▜▌▐▛▀▚▖ ▝▀▚▖  █  ▐▌ ▝▜▌▐▌▝▜▌ #
# ▐▌ ▐▌▐▌ ▐▌▝▚▄▞▘▝▚▄▞▘▐▌  ▐▌▐▙▄▄▖▐▌  ▐▌  █      ▐▌   ▐▌ ▐▌▐▌ ▐▌▗▄▄▞▘▗▄█▄▖▐▌  ▐▌▝▚▄▞▘ #
######################################################################################                                                                                  

if [ "$EUID" -ne 0 ]; then
  printf "${c_italic}${c_red}%s\n${c_reset}" "[Error]: Please Run as Root!"
  exit 1
fi

if [ $# -eq 0 ]; then
    printf "${c_magenta}%s\n${c_reset}" "
##########################################################################
# ▗▄▄▄▖▗▖   ▗▄▄▄▖ ▗▄▄▖▗▄▄▄▖▗▄▄▖ ▗▄▄▄▖ ▗▄▄▖ ▗▄▄▖ ▗▄▖ ▗▖ ▗▖▗▄▄▖  ▗▄▖▗▖  ▗▖ #
# ▐▌   ▐▌   ▐▌   ▐▌     █  ▐▌ ▐▌  █  ▐▌   ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▐▌ ▐▌▝▚▞▘  #
# ▐▛▀▀▘▐▌   ▐▛▀▀▘▐▌     █  ▐▛▀▚▖  █  ▐▌   ▐▌   ▐▌ ▐▌▐▌ ▐▌▐▛▀▚▖▐▌ ▐▌ ▐▌   #
# ▐▙▄▄▖▐▙▄▄▖▐▙▄▄▖▝▚▄▄▖  █  ▐▌ ▐▌▗▄█▄▖▝▚▄▄▖▝▚▄▄▖▝▚▄▞▘▐▙█▟▌▐▙▄▞▘▝▚▄▞▘ ▐▌   #
#                                                                        #
#    ▗▄▄▄  ▗▄▖▗▄▄▄▖▗▄▄▄▖▗▄▄▄▖▗▖   ▗▄▄▄▖ ▗▄▄▖                             #
#    ▐▌  █▐▌ ▐▌ █  ▐▌     █  ▐▌   ▐▌   ▐▌                                #
#    ▐▌  █▐▌ ▐▌ █  ▐▛▀▀▘  █  ▐▌   ▐▛▀▀▘ ▝▀▚▖                             #
#  ▄ ▐▙▄▄▀▝▚▄▞▘ █  ▐▌   ▗▄█▄▖▐▙▄▄▖▐▙▄▄▖▗▄▄▞▘                             #
##########################################################################
"
    printf "\n${c_italic}${c_yellow}%s\n${c_reset}" "No Arguments Supplied, Returning Help..."
    help
    exit 0
fi

# Parse Arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            help
            exit 0
            ;;
        -i|--install) 
            # todo: implement subargments to install gaming packages etc
            check_required_packages "${required_packages[@]}"
            check_package_managers
            parse_json
            install_packages "$packages"
            install_nvidia_drivers
            clean_up
            shift
            ;;
        -g|--gits)
            parse_json
            handle_gits "${gits[@]}"
            clean_up
            shift
            ;;
        -s|--settings)
            printf "${c_italic}${c_yellow}%s\n\n${c_reset}" "you did s"
            clean_up
            shift
            ;;
        -f|--flatpaks)
            required_packages+=("flatpak")
            check_required_packages "${required_packages[@]}"
            parse_json
            install_flatpaks "${flatpaks[@]}"
            clean_up
            shift
            ;;
        *)
            printf "${c_italic}${c_red}%s\n${c_reset}" "[Error]: Unknown argument! '$1'"
            exit 0
            ;;
    esac
done