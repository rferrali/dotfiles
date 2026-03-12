# My dotfiles managed with chezmoi

## Setup

The following commands will install chezmoi in `~/.local/bin` and apply my dotfiles to your home directory.

```bash
sh -c "$(curl -fsLS get.chezmoi.io/lb)" # install chezmoi
chezmoi init --apply rferrali
```

## Help

For help, please visit the [chezmoi documentation](https://www.chezmoi.io/docs/).

## Setups

### Ubuntu

Command line utilities only, for use on WSL or a server. 

### MacOS

Full setup for MacOS, including Homebrew and applications.

### Fedora

Full setup for Fedora, including DNF and applications. Post installation steps:

- Install fonts: copy to `/usr/local/share/fonts/` then run `fc-cache -fv`
