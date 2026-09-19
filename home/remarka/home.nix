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

  # Global setting
  gtk = {
    enable = true;

    font = {
      name = "JetBrains Mono";
      package = pkgs.jetbrains-mono;
      size = 12;
    };
  };
  
  # Global font
  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      monospace = [ "JetBrains Mono" ];
      sansSerif = [ "JetBrains Mono" ];
    };
  };
  
  # Mouse Cursor
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 20;
  
    gtk.enable = true;
    x11.enable = true;
  };

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

  # Better look for the terminal with Starship
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;

      line_break.disabled = true;      

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
    };
  };

  # ZSH
  programs.zsh = {
    enable = true;

    enableCompletion = true;

    autosuggestion = {
      enable = true;
      strategy = [ "history" ];
    };

    syntaxHighlighting.enable = true;

    history = {
      size = 10000;
      save = 10000;
      share = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    historySubstringSearch = {
      enable = true;
      searchUpKey = [ "^[[A" ];
      searchDownKey = [ "^[[B" ];
    };

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
