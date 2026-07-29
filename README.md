# nix-home 🐬

> [NixOS](https://nixos.org) & [Home Manager](https://nix-community.github.io/home-manager) configuration files

This repository contains my development environment that I use for school and work.
Feel free to copy my dotfiles or leave suggestions!

## 🎨 Colour Scheme • [Catppuccin](https://github.com/catppuccin/catppuccin)

The common theme across all my applications! I use the **Mocha** flavour.

## 📝 Editor • [Neovim](https://neovim.io)

A sweet command-based editor that speeds up coding.
Even if you don't want to use Neovim, I recommend getting a Vim bindings plugin in an editor like VSCode.
All of my config for Neovim is under `src/nvim`.
I use [lazy.nvim](https://github.com/folke/lazy.nvim) to manage plugins.

<details><summary>Awesome plugins ✨</summary>

- `nvim-treesitter`: Improved syntax highlighting
- `nvim-cmp`: Code completion engine
- `lspsaga.nvim`: Improved LSP commands
- `conform.nvim` & `nvim-lint`: Formatting and linting
- `telescope.nvim`: Fast fuzzy finder (No directory trees here!)
- `harpoon`: Quick navigation
- `lualine.nvim` & `bufferline.nvim`: Top and bottom lines UI
- `dashboard-nvim`: Startup page
- `nvim-material-icon`: Icon set for files
- `presence.nvim`: Discord rich presence to flex

</details>

## 💾 Terminal • [Ghostty](https://ghostty.org)

I use [fish](https://fishshell.com) to make using the CLI easier.
[Starship](https://starship.rs) gives a clean look to the prompt!

## 🪟 Tiling Compositor • [niri](https://niri-wm.github.io/niri/index.html)

Tiling windows means I can navigate quickly and effortlessly to what I need.
I recommend compiling a list of keybinds that you find easy to remember and use.
I previously used [XMonad](https://xmonad.org) and [Hyprland](https://hypr.land/).

## 🛠️ Managing dotfiles • [Home Manager](https://nix-community.github.io/home-manager)

I dislike having a system that requires mental gymnastics to understand.
Home Manager allows for a declarative approach to installing and configuring software.
For instance, all the packages on my system are in `home.packages`, so I can know what's installed at a glance.
Most of my setup can be found in `home.nix`!

## License

[GPL-3.0](https://github.com/mathletedev/nix-home/blob/main/LICENSE)
