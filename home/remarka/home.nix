{ pkgs, inputs, ... }:

let
  # Cursor configuration.
  # Change these values here and both GTK/X11 and Niri will use them.
  cursorTheme = "Bibata-Modern-Classic";
  cursorSize = 20;
in
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  home.username = "remarka";
  home.homeDirectory = "/home/remarka";
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;


  # ============================================================
  # Configuration files
  # ============================================================

  # Niri config.
  #
  # The source config.kdl contains @CURSOR_THEME@ and
  # @CURSOR_SIZE@ placeholders. Home Manager replaces them with
  # the cursor values defined above.
  xdg.configFile."niri/config.kdl".text =
    builtins.replaceStrings
      [
        "@CURSOR_THEME@"
        "@CURSOR_SIZE@"
      ]
      [
        cursorTheme
        (toString cursorSize)
      ]
      (builtins.readFile ./niri/config.kdl);

  # Noctalia config.
  xdg.configFile."noctalia/config.toml".source =
    ./noctalia/config.toml;


  # ============================================================
  # GTK
  # ============================================================

  gtk = {
    enable = true;
  
    font = {
      name = "JetBrains Mono";
      package = pkgs.jetbrains-mono;
      size = 12;
    };
  };

  # ============================================================
  # Fonts
  # ============================================================

  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      monospace = [ "JetBrains Mono" ];
      sansSerif = [ "JetBrains Mono" ];
    };
  };


  # ============================================================
  # Mouse cursor
  #
  # cursorTheme and cursorSize are defined at the top of this file.
  # ============================================================

  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    name = cursorTheme;
    size = cursorSize;

    gtk.enable = true;
    x11.enable = true;
  };


  # ============================================================
  # Kitty terminal
  # ============================================================

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


  # ============================================================
  # Starship prompt
  # ============================================================

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


  # ============================================================
  # Zsh
  # ============================================================

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

      rebuild =
        "sudo nixos-rebuild switch --flake ~/nixos-config#personal-laptop-nixos";
    };
  };


  # ============================================================
  # Git
  # ============================================================

  programs.git = {
    enable = true;
  };


  # ============================================================
  # Niri / desktop
  # ============================================================

  # Screen locking.
  programs.swaylock.enable = true;

  # Desktop shell.
  programs.noctalia = {
    enable = true;
  };


  # ============================================================
  # User packages
  # ============================================================

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
    
    # File editor
    kdePackages.kate
  ];
}
