{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/desktop.nix
      ../../modules/niri.nix
      ../../modules/maintenance.nix
      ../../modules/wireguard.nix
      ../../modules/ssh.nix
    ];

  boot.loader.systemd-boot = {
    enable = true;

    # Keep only the 5 newest NixOS generations in the boot menu.
    configurationLimit = 5;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "personal-laptop-nixos";
  
  users.users.remarka = {
    isNormalUser = true;
    description = "Elena Stroiu";

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    shell = pkgs.zsh;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.remarka = import ../../home/remarka/home.nix;
  };

  system.stateVersion = "26.05";

}
