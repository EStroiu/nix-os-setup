# NixOS Configuration

Personal multi-host NixOS configuration using:

- Nix flakes
- Home Manager
- reusable NixOS modules
- host-specific hardware and boot configuration
- Git as the source of truth

The goal is to make machines feel the same where that makes sense, while keeping hardware, disks and boot configuration specific to each computer.

---

# Repository structure

```text
nixos-config/
├── flake.nix
├── flake.lock
├── README.md
├── .gitignore
│
├── hosts/
│   ├── personal-laptop-nixos/
│   │   ├── configuration.nix
│   │   └── hardware-configuration.nix
│   │
│   └── work-laptop-nixos/
│       ├── configuration.nix
│       └── hardware-configuration.nix
│
├── modules/
│   ├── laptop.nix
│   ├── common.nix
│   ├── desktop.nix
│   ├── niri.nix
│   ├── maintenance.nix
│   ├── ssh.nix
│   └── wireguard.nix
│
├── home/
│   └── remarka/
│       ├── home.nix
│       ├── niri/
│       │   └── config.kdl
│       └── noctalia/
│           └── config.toml
│
└── scripts/
    ├── rebuild.sh
    └── new-host.sh
```

---

# Configuration model

The repository has three main configuration levels.

## `hosts/`

`hosts/` answers:

> What is special about this physical computer?

Each computer has its own directory:

```text
hosts/<hostname>/
├── configuration.nix
└── hardware-configuration.nix
```

Host configuration should contain only things that genuinely depend on the machine, for example:

- hostname
- bootloader configuration
- filesystem/storage configuration
- ZFS configuration
- encryption configuration
- hardware-specific drivers or options
- `networking.hostId`
- `system.stateVersion`

Do not put normal applications, shell preferences, terminal preferences or desktop preferences here.

---

## `modules/`

`modules/` contains reusable NixOS system configuration.

`modules/laptop.nix` is the shared laptop profile.

It imports the common reusable modules and connects the shared Home Manager configuration.

Conceptually:

```text
host
 ↓
modules/laptop.nix
 ↓
shared NixOS modules
 +
home/remarka/home.nix
```

A setting belongs in a reusable module when it is something that should normally apply to multiple machines.

Examples:

```text
common system defaults
desktop infrastructure
Niri system support
SSH service
maintenance
networking support
VPN support
```

---

## `home/remarka/`

This is the shared user environment.

It answers:

> How should my account look and behave on every machine?

Examples include:

- user applications
- shell configuration
- shell aliases and functions
- prompt configuration
- terminal configuration
- Git preferences
- editor preferences
- Niri keybindings
- Noctalia configuration
- cursor/theme preferences
- user-level dotfiles

Changes here should normally appear on every machine after pulling the repository and rebuilding.

---

# Where should a change go?

| Change | Location |
|---|---|
| Hostname | `hosts/<host>/configuration.nix` |
| Disk/filesystem setup | `hosts/<host>/configuration.nix` |
| Generated filesystem/hardware detection | `hosts/<host>/hardware-configuration.nix` |
| Bootloader | `hosts/<host>/configuration.nix` |
| ZFS host ID | relevant host configuration |
| Shared system service | `modules/` |
| Shared desktop behavior | `modules/` |
| User application | `home/remarka/home.nix` |
| Shell configuration | `home/remarka/home.nix` |
| Terminal configuration | `home/remarka/home.nix` |
| Git configuration | `home/remarka/home.nix` |
| Niri user config | `home/remarka/niri/` |
| Noctalia user config | `home/remarka/noctalia/` |
| External flake dependency | `flake.nix` |
| Exact dependency revisions | `flake.lock` |
| Secrets/private keys/passwords | **never plaintext in this repository** |

A useful rule is:

```text
Does only one physical machine need it?
    → hosts/

Should all NixOS machines need it?
    → modules/

Is it part of my personal environment?
    → home/remarka/
```

---

# Hosts in `flake.nix`

Hosts are declared explicitly.

A helper avoids repeating the same NixOS/Home Manager setup:

```nix
let
  mkHost = hostname:
    nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./hosts/${hostname}/configuration.nix

        home-manager.nixosModules.home-manager

        {
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
    };
in
{
  nixosConfigurations = {
    personal-laptop-nixos = mkHost "personal-laptop-nixos";
    work-laptop-nixos = mkHost "work-laptop-nixos";
  };
}
```

Adding another normal x86-64 host therefore requires only:

```nix
new-host = mkHost "new-host";
```

plus:

```text
hosts/new-host/
```

---

# Normal day-to-day workflow

Enter the repository:

```bash
cd ~/nixos-config
```

Edit files.

Stage new files before using the flake:

```bash
git add .
```

New files must be staged because the flake is evaluated from the Git source tree.

Check and build the current host:

```bash
rebuild-check
```

Or only build:

```bash
rebuild-test
```

Apply immediately:

```bash
rebuild
```

Install for the next boot without switching the running system:

```bash
rebuild-boot
```

After verifying the system:

```bash
git status
git add .
git commit -m "Describe the change"
git push
```

---

# Rebuild helper

`scripts/rebuild.sh` determines the target from:

```bash
hostname
```

For example, on the work laptop:

```text
work-laptop-nixos
```

automatically maps to:

```text
.#work-laptop-nixos
```

The script also checks that:

```text
hosts/<hostname>/configuration.nix
```

actually exists before rebuilding.

Commands:

```bash
./scripts/rebuild.sh check
./scripts/rebuild.sh build
./scripts/rebuild.sh switch
./scripts/rebuild.sh boot
```

Zsh provides convenient wrappers:

```bash
rebuild-check
rebuild-test
rebuild
rebuild-boot
```

This avoids hardcoding a particular machine into aliases.

---

# Installing NixOS on a new machine

There are two separate situations:

1. a normal fresh installation;
2. an unusual machine with an existing multiboot/ZFS/encrypted storage setup.

Do not treat them the same.

---

# Normal fresh installation

## 1. Boot the NixOS installer

Boot the NixOS ISO in UEFI mode.

For an ordinary laptop with no special existing disk requirements, perform a normal NixOS installation first.

Do not try to use this repository before proving that the basic installation can boot.

The initial installation only needs to provide:

```text
working bootloader
working filesystem
working user
working network
```

The repository will replace the rest afterward.

---

## 2. Boot the installed system

Boot the newly installed NixOS system normally.

Confirm:

```bash
hostname
```

and:

```bash
ip addr
```

Make sure networking works.

---

## 3. Obtain Git

If Git is not installed yet:

```bash
nix-shell -p git
```

---

## 4. Clone this repository

SSH:

```bash
git clone git@github.com:EStroiu/nix-os-setup.git ~/nixos-config
```

If SSH authentication has not been configured yet, HTTPS can be used temporarily.

Enter the repo:

```bash
cd ~/nixos-config
```

---

## 5. Create the new host

Choose the final hostname first.

Example:

```text
new-laptop-nixos
```

Run:

```bash
./scripts/new-host.sh new-laptop-nixos
```

The script creates:

```text
hosts/new-laptop-nixos/
├── configuration.nix
└── hardware-configuration.nix
```

`hardware-configuration.nix` is copied from the newly installed machine.

Never copy another computer's `hardware-configuration.nix`.

---

## 6. Edit the host configuration

Open:

```bash
nano hosts/new-laptop-nixos/configuration.nix
```

The generated skeleton already imports:

```nix
./hardware-configuration.nix
../../modules/laptop.nix
```

and sets the hostname.

Now copy/adapt only the machine-specific parts of:

```text
/etc/nixos/configuration.nix
```

Typical examples are:

```text
bootloader
EFI mount settings
filesystem/storage settings
hardware-specific settings
```

Do not copy generic desktop/user configuration from `/etc/nixos/configuration.nix`.

That functionality comes from the shared modules.

---

## 7. Add the host to the flake

Open:

```bash
nano flake.nix
```

Add:

```nix
new-laptop-nixos = mkHost "new-laptop-nixos";
```

under:

```nix
nixosConfigurations
```

---

## 8. Stage the new host

```bash
git add .
```

---

## 9. Validate

```bash
nix flake check
```

Then build the new host:

```bash
./scripts/rebuild.sh build
```

Do not activate a configuration that fails to build.

---

## 10. Activate cautiously

For the first conversion from the installer-generated configuration to this repository, prefer:

```bash
./scripts/rebuild.sh boot
```

Then reboot:

```bash
sudo reboot
```

This leaves the currently running installation untouched and activates the new configuration on the next boot.

---

## 11. Verify the new system

After reboot:

```bash
hostname
```

Verify the Home Manager activation:

```bash
systemctl status home-manager-remarka.service --no-pager
```

Check failed services:

```bash
systemctl --failed
```

Test the applications/environment you depend on.

---

## 12. Commit the host

Once everything works:

```bash
cd ~/nixos-config

git add .

git commit -m "Add new-laptop-nixos"

git push
```

The new machine is now reproducible from the repository.

---

# Complex storage / dual boot / ZFS machines

Do not use a generic installation recipe for a machine that already contains:

```text
multiple operating systems
ZFS pools
ZFSBootMenu
encrypted datasets
unusual EFI layouts
LVM
custom partition layouts
```

In these cases:

1. inspect the existing disk layout first;
2. preserve the existing EFI partition unless there is a deliberate reason not to;
3. establish a bootable minimal NixOS installation;
4. create the host-specific storage and boot configuration;
5. only then attach the shared `modules/laptop.nix` profile.

The helper scripts deliberately do **not** modify partitions, encryption, ZFS pools or bootloaders.

The work laptop is an example of this category.

Its ZFS, encryption and boot settings remain under:

```text
hosts/work-laptop-nixos/
```

and are not shared with other machines.

---

# `hardware-configuration.nix`

Every physical machine must have its own generated:

```text
hosts/<host>/hardware-configuration.nix
```

Do not copy this file between machines.

It contains detected information such as:

```text
filesystem UUIDs
filesystem types
kernel modules
CPU/platform defaults
swap devices
hardware detection
```

Treat it as machine-specific generated configuration.

---

# `system.stateVersion`

`system.stateVersion` is compatibility state for that installation.

It is not simply the current NixOS release number.

Keep the value associated with the installation.

Do not update it just because the flake inputs were updated.

The same general rule applies to Home Manager's `home.stateVersion`.

---

# Updating dependencies

Check the current repository first:

```bash
cd ~/nixos-config
git status
```

Update:

```bash
nix flake update
```

Inspect:

```bash
git diff flake.lock
```

Validate:

```bash
nix flake check
```

Build the current host:

```bash
rebuild-test
```

If successful:

```bash
rebuild
```

Then commit:

```bash
git add flake.lock
git commit -m "Update flake inputs"
git push
```

---

# Adding software

Decide whether the software belongs to the system or the user.

## User software

Prefer:

```text
home/remarka/home.nix
```

for programs used by the normal desktop user.

This ensures every host gets the same user environment.

## System software or services

Use:

```text
modules/
```

when software is required system-wide or provides a system service.

## Machine-specific software

Only put software in:

```text
hosts/<host>/
```

when there is a real machine-specific reason.

---

# User configuration

The shared Home Manager configuration lives at:

```text
home/remarka/home.nix
```

This is the main location for things such as:

```text
shell
prompt
terminal
Git
CLI tools
applications
cursor/theme
aliases
custom shell functions
```

Application-specific files may live beside it:

```text
home/remarka/<application>/
```

and be deployed through Home Manager.

The repository should be the source of truth instead of manually editing generated files under `~/.config`.

---

# Secrets

Do not store plaintext secrets in this repository.

This includes:

```text
SSH private keys
VPN private keys
passwords
API keys
tokens
private certificates
Wi-Fi credentials
```

Do not rely on `.gitignore` as secret protection.

Values embedded in Nix expressions may become available in the Nix store.

Keep secrets outside the repository or use an encrypted Nix secret-management solution when needed.

---

# SSH keys

SSH keys are currently machine-local.

They normally live in:

```text
~/.ssh/
```

Recommended permissions:

```bash
chmod 700 ~/.ssh

chmod 600 ~/.ssh/id_ed25519
chmod 600 ~/.ssh/id_rsa

chmod 644 ~/.ssh/*.pub
chmod 644 ~/.ssh/known_hosts
```

Never commit private keys to this repository.

---

# Recovery

Before large changes, commit the current working state:

```bash
git add .
git commit -m "Known good configuration"
git push
```

NixOS also retains system generations.

List them with:

```bash
nixos-rebuild list-generations
```

If a new system does not boot correctly, select an older NixOS generation from the boot menu.

Git and NixOS generations provide two different recovery mechanisms:

```text
Git
    restores configuration source

NixOS generations
    restore previously built systems
```

Keep both.

---

# Important design rules

Keep host configuration small.

If the same setting appears in multiple hosts, consider moving it to a shared module.

Keep personal preferences in Home Manager.

Do not copy `hardware-configuration.nix` between machines.

Do not hardcode a hostname in shared shell commands.

Do not put secrets in Nix expressions.

Do not automate destructive storage operations merely for convenience.

Prefer:

```text
simple
explicit
shared where appropriate
host-specific where necessary
```

over abstraction for its own sake.

---

# Typical workflow

For normal configuration work:

```bash
cd ~/nixos-config

# edit files

git add .

rebuild-check

rebuild

# test

git add .
git commit -m "Describe the change"
git push
```

For a riskier boot/system change:

```bash
cd ~/nixos-config

git add .

rebuild-check

rebuild-boot

sudo reboot
```

For a new machine:

```text
install plain NixOS
        ↓
boot it successfully
        ↓
clone repository
        ↓
scripts/new-host.sh <hostname>
        ↓
add machine-specific boot/storage configuration
        ↓
add one mkHost line to flake.nix
        ↓
git add .
        ↓
nix flake check
        ↓
rebuild-test
        ↓
rebuild-boot
        ↓
reboot and verify
        ↓
commit + push
```

The repository should describe the desired system state.

The Nix files document **what the machines run**.

This README documents **how the configuration is structured and maintained**.
