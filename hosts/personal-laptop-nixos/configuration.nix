{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/desktop.nix
      ../../modules/niri.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "personal-laptop-nixos";
  
  users.users."remarka" = {
    isNormalUser = true;
    description = "Elena Stroiu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.remarka = import ../../home/remarka/home.nix;
  };

  system.stateVersion = "26.05";

}
