#!/usr/bin/env bash

set -o errexit		# abort on nonzero exitstatus
set -o nounset		# abort on ubound variables
set -o pipefail		# don't hide errors within pipes

IFS='\n\t'

DOTFILES="$HOME/dotfiles"
dependencies=(stow git i3)

# prints an info msg to the screen 
info() 
{
	printf "\r  [\033[00;34mINFO\033[0m] $1\n"	
}

# prints a success msg to the screen
success()
{
	printf "\r\033[2K  [\033[00;32m OK \033[0m] $1\n"
}

# prints an error msg to the screen
error()
{
    printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
    exit 1  
}

# verifies if the user has sudo permission
check_sudo() 
{
	if [[ "$(id -u)" -ne 0 ]]; then
		error "Permission denied. Please, run this script as root"
	fi
}

# verifies if apt is the main packager manager
check_apt() 
{
	if ! command -v apt &> /dev/null; then
		info "This script only works with a Debian-based distribution. Sorry"
		fail "System incompatibility"
	fi
}

install_dependencies() 
{
	info "Updating packages..."
	if ! sudo apt-get update -q > /dev/null && sudo apt-get upgrade -q -y > /dev/null; then
		fail "Failed to update packages. Please check your network connection"
	fi

	for lib in "${dependencies[@]}"; do
		info "Checking and installing ${lib} if not present..."
		if dpkg -s "${lib}" &> /dev/null; then
			success "${lib} is already installed."
		else
			if sudo apt-get install "${lib}" -q --yes > /dev/null; then
				success "${lib} is installed successfully"
			else
				fail "Failed to install ${lib}. Please check the package name or your source list"
			fi
		fi
	done

	info "All dependencies have been installed and verified."
}

clone_dotfiles() 
{
	info "Clonning dotfiles repository into ${DOTFILES}..."
	git clone https://github.com/gabrielh-muniz/dotfiles.git "$DOTFILES"
	
	info "Changing directory to $DOTFILES"
	cd "$DOTFILES" || error "Failed to change directory to $DOTFILES"

	info "Stow everything..."
	stow *

}

runtime() 
{
	local os_type=$(uname)
	case "${os_type}" in
		"Linux")
		{
			info "Running on Linux"
			check_sudo
			check_apt
			install_dependencies
			clone_dotfiles
		} ;;
		*)
		{
			error "Unsupported OS"
		} ;;
	esac
}
