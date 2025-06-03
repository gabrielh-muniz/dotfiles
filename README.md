<h2 align="center">
    DOTFILES
</h2>

- OS: Arch
- WN: Hyprland 
- Bar: Waybar 
- Launcher: Rofi
- Terminal: Ghostty
- Prompt: Created by me 
- Shell: Zsh
- Editor: Neovim
- Font: JetBrains Mono
- Colorscheme: Gruvbox
- Notifications: Dunst
- Multiplexer: Tmux w/ scripts

## Dependencies

Install `GNU Stow` with your favorite package manager

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
