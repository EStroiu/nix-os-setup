{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    
    ../../modules/common.nix
    ../../modules/desktop.nix
    ../../modules/niri.nix
    ../../modules/maintenance.nix
    ../../modules/wireguard.nix
    ../../modules/ssh.nix
  ];

  # ------------------------------------------------------------
  # ZFS
  # ------------------------------------------------------------

  # Same physical machine as AlmaLinux/Ubuntu.
  networking.hostId = "00bab10c";

  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs = {
    devNodes = "/dev/disk/by-partuuid";

    # Only ask for the independent NixOS encryption key.
    requestEncryptionCredentials = [
      "zroot/ROOT/nixos"
    ];

    # Keep ZFS's protection against accidentally importing
    # a pool that appears active elsewhere.
    forceImportRoot = false;
  };

  # ------------------------------------------------------------
  # Bootloader
  # ------------------------------------------------------------

  boot.loader.systemd-boot = {
    enable = true;

    # ESP is only 512 MiB, so don't keep many kernels here.
    configurationLimit = 2;

    # Existing ZFSBootMenu used by AlmaLinux and Ubuntu.
    extraEntries."zfsbootmenu.conf" = ''
      title ZFSBootMenu - AlmaLinux / Ubuntu
      efi /EFI/ZBM/VMLINUZ.EFI
      sort-key z_zfsbootmenu
    '';
  };

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  # ------------------------------------------------------------
  # Networking
  # ------------------------------------------------------------

  networking.hostName = "work-laptop-nixos";
  networking.networkmanager.enable = true;

  # ------------------------------------------------------------
  # User
  # ------------------------------------------------------------

  users.users.remarka = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.remarka =
    import ../../home/remarka/home.nix;

  # sudo for wheel users
  security.sudo.enable = true;

  # ------------------------------------------------------------
  # Basic utilities
  # ------------------------------------------------------------

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  # ------------------------------------------------------------
  # Nix
  # ------------------------------------------------------------

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Keep whatever value nixos-generate-config originally gave you
  # if it differs from this.
  system.stateVersion = "26.05";
}
