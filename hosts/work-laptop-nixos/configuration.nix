{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/laptop.nix
  ];

  # ------------------------------------------------------------
  # Machine identity
  # ------------------------------------------------------------

  networking.hostName = "work-laptop-nixos";

  # Required for this machine's existing ZFS pool.
  networking.hostId = "00bab10c";


  # ------------------------------------------------------------
  # ZFS
  # ------------------------------------------------------------

  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs = {
    devNodes = "/dev/disk/by-partuuid";

    requestEncryptionCredentials = [
      "zroot/ROOT/nixos"
    ];

    forceImportRoot = false;
  };


  # ------------------------------------------------------------
  # Boot
  # ------------------------------------------------------------

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 5;

    extraEntries."zfsbootmenu.conf" = ''
      title ZFSBootMenu - AlmaLinux / Ubuntu
      efi /EFI/ZBM/VMLINUZ.EFI
      sort-key z_zfsbootmenu
    '';
  };

  boot.loader.timeout = 10;

  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };


  # ------------------------------------------------------------
  # Compatibility
  # ------------------------------------------------------------

  system.stateVersion = "26.05";
}
