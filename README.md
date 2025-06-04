<h2 align="center">
    DOTFILES
</h2>

![Showcase](https://github.com/user-attachments/assets/bd19d611-5468-4452-bcca-8518fac5f959)

- OS: ![Arch](https://archlinux.org/)
- WN: ![Hyprland](https://hyprland.org/)
- Bar: ![Waybar](https://github.com/Alexays/Waybar)
- Launcher: ![Rofi](https://github.com/lbonn/rofi)
- Terminal: ![Ghostty](https://ghostty.org/)
- Prompt: ![Starship](https://starship.rs/)
- Shell: ![Zsh](https://www.zsh.org/)
- Editor: ![Neovim](https://neovim.io/)
- Font: ![JetBrains Mono](https://www.jetbrains.com/lp/mono/)
- Colorscheme: ![Gruvbox](https://github.com/morhetz/gruvbox)
- Notifications: ![Dunst](https://github.com/dunst-project/dunst)
- Multiplexer: ![Tmux w/ scripts](https://github.com/tmux/tmux)

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
