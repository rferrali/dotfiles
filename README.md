# My dotfiles managed with chezmoi

## Setup

The following commands will install chezmoi in `~/.local/bin` and apply my dotfiles to your home directory.

```bash
sh -c "$(curl -fsLS get.chezmoi.io/lb)"
~/.local/bin/chezmoi init --apply rferrali
```

## Setups

### Ubuntu

Command line utilities only, for use on WSL or a server. 

### MacOS

Full setup for MacOS, including Homebrew and applications.

### Fedora

Full setup for Fedora, including DNF and applications. Post installation steps:

- Install fonts: copy to `/usr/local/share/fonts/` then run `fc-cache -fv`
- Download .rpm packages: 
    - [Dropbox](https://www.dropbox.com/install-linux)
    - [Positron](https://positron.posit.co/download.html)
    - [Devpod](https://www.devpod.io/docs/installation/linux)
- Install Claude code: 

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

## Help

For help, please visit the [chezmoi documentation](https://www.chezmoi.io/docs/).

