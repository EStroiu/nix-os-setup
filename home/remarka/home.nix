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
  xdg.configFile."noctalia/config.toml".source = ./noctalia/config.toml;

  # Kitty terminal
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrains Mono";
      package = pkgs.jetbrains-mono;
      size = 12;
    };

    settings = {
      # Appearance
      window_padding_width = 10;
      background_opacity = 0.95;

      # Behaviour
      scrollback_lines = 10000;
      enable_audio_bell = false;

      # Don't ask for confirmation when closing a terminal window.
      confirm_os_window_close = 0;
    };
  };

  # Better look for the terminal
  programs.starship = {
    enable = true;
    enableFishIntegration = true;

    settings = {
      add_newline = false;

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
    };
  };

  # Fish terminal
  programs.fish = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#personal-laptop-nixos";
    };
  };
 
  # Git
  programs.git = {
    enable = true;
  };

  # Stuff for Niri
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
