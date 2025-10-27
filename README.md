# server-image

A repository for my VM container host, based on [ucore-minimal](https://github.com/ublue-os/ucore?)

Adds:

- docker-ce (no podman)
- lazydocker and dtop
- dockge
- bootc
- helix (as the default editor)
- various language servers for helix
- htop
- cron
- disables firewalld
- `NOPASSWD: ALL` for `wheel` users

# Using (Proxmox)

1. Create a butane file `autorebase.butane` from the [example](https://github.com/njanke96/server-image/blob/main/butane/autorebase.example.butane)

2. Transpile

```bash
butane --pretty --strict autorebase.butane > autorebase.ign
```

3. Copy the `autorebase.ign` file to the Proxmox host.

4. Follow the [CoreOS Proxmox Guide](https://docs.fedoraproject.org/en-US/fedora-coreos/provisioning-proxmoxve/) using the generated ignition file. Make a template right before the "Configure Ignition file delivery via cloud-init" step to avoid needing to repeat all the steps each time.

5. On first boot the VM should rebase to the latest image in the registry, and set up the SSH keys for a ready-to-use container host.

# Upgrading via bootc

TODO

# Justfile Documentation

The `Justfile` contains various commands and configurations for building and managing container images and virtual machine images using Podman and other utilities.
To use it, you must have installed [just](https://just.systems/man/en/introduction.html) from your package manager or manually. It is available by default on all Universal Blue images.

## Environment Variables

- `image_name`: The name of the image (default: "image-template").
- `default_tag`: The default tag for the image (default: "latest").

## Building The Image

### `just build`

Builds a container image using Podman.

```bash
just build $target_image $tag
```

Arguments:
- `$target_image`: The tag you want to apply to the image (default: `$image_name`).
- `$tag`: The tag for the image (default: `$default_tag`).
