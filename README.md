<h2 align="center">
    <a name="top" title="dotfiles">~/.&nbsp;📂</a> DOTFILES<br/> <sup><sub>made by <a href="https://github.com/gabrielh-muniz">me</a> </sub></sup>
</h2>

![Showcase](https://github.com/user-attachments/assets/5f5bf4d3-74c5-48b9-b5e5-a207de936f0c)

- OS: Debian GNU/Linux 12 (bookworm)
- WN: i3
- Bar: i3status
- Launcher: Rofi
- Terminal: Kitty
- Prompt: Starship
- Shell: Bash
- Editor: Neovim
- Font: Meslo
- Fetch: Neofetch
- Colorscheme: Gruvbox

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
