{ pkgs, ... }:

{
  # Enable modern Nix commands and flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Packages we want available on every machine.
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
    ripgrep
    fd
    tree
    htop
    jq
    unzip
    zip
  ];
}
