<h2 align="center">
    <a name="top" title="dotfiles">~/.&nbsp;📂</a> DOTFILES<br/> <sup><sub>made by <a href="https://github.com/gabrielh-muniz">me</a> </sub></sup>
</h2>

- OS: Debian GNU/Linux 12 (bookworm)
- WN: i3
- Bar: i3status
- Launcher: dmenu
- Terminal: st
- Shell: Bash
- Editor: Neovim
- Font: Meslo 
- Fetch: neofetch
- Colorscheme: gruvbox

## Dependencies

GNU Stow:

```bash
# Debian-based
sudo apt install stow
```

```bash
# macOS
brew install stow
```

## Installation

Clone this repository:

```bash
git clone https://github.com/gabrielh-muniz/dotfiles.git ~/.dotfiles
```

## Usage

Change directory to `~/.dotfiles` and stow the packages you want (remember to backup your previous config)

```bash
cd ~/.dotfiles
stow *      # * = all packages / stow <package_name> for individual
```
