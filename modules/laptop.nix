{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ./desktop.nix
    ./niri.nix
    ./maintenance.nix
    ./wireguard.nix
    ./ssh.nix
  ];

  # Shared user account.
  users.users.remarka = {
    isNormalUser = true;
    description = "Elena Stroiu";

    extraGroups = [
      "networkmanager"
      "wheel"
    ];

    shell = pkgs.zsh;
  };

  # Zsh needs to exist as an allowed login shell.
  programs.zsh.enable = true;

  # The same Home Manager configuration is used on every laptop.
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.remarka =
    import ../home/remarka/home.nix;
}
