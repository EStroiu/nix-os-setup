{ pkgs, ... }:

{
  # Enable modern Nix commands and flakes.
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Networking available on all machines.
  networking.networkmanager.enable = true;

  # Regional settings.
  time.timeZone = "Europe/Amsterdam";

  # Use zsh terminal.	
  programs.zsh.enable = true;

  # Makes completion data from system packages available to Zsh.
  environment.pathsToLink = [ "/share/zsh" ];

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
  
    LC_TIME = "en_GB.UTF-8";
  };

  nixpkgs.config.allowUnfree = true;

  # Keep a few basic recovery/admin tools available system-wide.
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
  ];
}
