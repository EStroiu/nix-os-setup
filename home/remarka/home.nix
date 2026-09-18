{ pkgs, inputs, ... }:

{

  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.username = "remarka";
  home.homeDirectory = "/home/remarka";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  xdg.configFile."niri/config.kdl".source = ./niri/config.kdl;

  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
    };
  };

  programs.git = {
    enable = true;
  };

  # Stuff for Niri
  programs.alacritty.enable = true; # terminal
  programs.swaylock.enable = true; # screen lock
  programs.noctalia = {
    enable = true;
  };

  home.packages = with pkgs; [
    # CLI utilities
    ripgrep
    fd
    tree
    htop
    jq

    # Archives
    unzip
    zip

    # System information
    fastfetch
  ];
}
