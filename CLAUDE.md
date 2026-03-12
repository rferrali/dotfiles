# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a [chezmoi](https://www.chezmoi.io/) dotfiles repository supporting macOS (darwin), Ubuntu, and Fedora.

## Key Commands

```bash
chezmoi apply          # apply dotfiles to home directory
chezmoi diff           # preview changes before applying
chezmoi data           # show all template variables
chezmoi edit ~/.zshrc  # edit a managed file by target path
chezmoi add <file>     # add a new file to management
```

## Architecture

**File naming conventions:**
- `dot_` prefix → becomes a dotfile (e.g., `dot_zshrc.tmpl` → `~/.zshrc`)
- `.tmpl` suffix → processed as a Go template before applying
- `empty_` prefix → creates an empty file (the source file is the template)

**Template data:** `.chezmoidata.yaml` defines all variables used in templates, including the full package lists per OS (`packages.darwin`, `packages.ubuntu`, `packages.fedora`) and zsh plugins (`zsh`).

**Templates use Go template syntax** with `{{ if eq .chezmoi.os "darwin" }}` / `{{ else if eq .chezmoi.os "linux" }}` blocks for platform branching, and `{{ range .packages.fedora.dnf_packages }}` for iterating package lists.

**`dot_bootstrap.sh.tmpl`** is a one-shot setup script (not managed as a regular dotfile) that installs packages via Homebrew (macOS), apt (Ubuntu), or dnf (Fedora), sets up Oh My Zsh, and installs zsh plugins.

**`README.md` is excluded** from deployment via `.chezmoiignore`.

## Adding Packages

To add a package, update the relevant section in `.chezmoidata.yaml` under `packages.<os>.<package_manager>`. The bootstrap script reads from these lists via template iteration.
