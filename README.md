# My dotfiles managed with chezmoi

## Setup

The following commands will install chezmoi in `~/.local/bin` and apply my dotfiles to your home directory.

```bash
sh -c "$(curl -fsLS get.chezmoi.io/lb)" # install chezmoi
chezmoi init --apply rferrali
```

## Help

For help, please visit the [chezmoi documentation](https://www.chezmoi.io/docs/).