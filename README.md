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

- Remove unnecessary packages:

```bash
sudo dnf remove firefox totem "libreoffice*" gnome-tour yelp
```

- Use Wifi-based geolocation: edit `/etc/geoclue/geoclue.conf` and make sure or BeaconDB is set as the URL. Then restart the geoclue service with `sudo systemctl restart geoclue`

```ini
[wifi]
enable=true
url=https://beacondb.net/v1/geolocate
```

- Install Portainer for Docker management. You can access the Portainer UI at `https://localhost:9443` after running the following commands:

```bash
docker volume create portainer_data

docker run -d \
  -p 8000:8000 \
  -p 9443:9443 \
  --name portainer \
  # starts the container automatically on system boot
  --restart=always \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v portainer_data:/data \
  portainer/portainer-ce:latest

```

## Help

For help, please visit the [chezmoi documentation](https://www.chezmoi.io/docs/).

