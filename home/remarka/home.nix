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
  # Ghostty terminal
  # ============================================================

  programs.ghostty = {
    enable = true;
  
    enableZshIntegration = true;
  
    settings = {
      # Font
      "font-family" = "JetBrains Mono";
      "font-size" = 12;
      
      # Do not show box with the current size
      "resize-overlay" = "never";
   
      # Use Catppuccin for the ANSI/application colour palette,
      # but keep the terminal itself very dark and neutral.
      theme = "Catppuccin Mocha";
  
      background = "0b0b0b";
      foreground = "e6e6e6";
  
      "cursor-color" = "f2f2f2";
      "cursor-text" = "0b0b0b";
  
      "selection-background" = "3a3a3a";
      "selection-foreground" = "ffffff";
  
      # Similar appearance to the previous Kitty setup.
      "background-opacity" = 0.95;
  
      "window-padding-x" = 10;
      "window-padding-y" = 10;
  
      # History
      "scrollback-limit" = 10000000;
  
      # No terminal bell.
      "bell-features" = "no-audio,no-system";
      
      # Clipboard behaviour.
      "clipboard-trim-trailing-spaces" = true;

      # Don't copy automatically just by selecting text.
      "copy-on-select" = false;
      
      keybind = [
        # Clipboard
        "ctrl+shift+c=copy_to_clipboard:plain"
        "ctrl+shift+v=paste_from_clipboard"
      
        # Create splits
        "ctrl+shift+right=new_split:right"
        "ctrl+shift+down=new_split:down"
      
        # Navigate between splits
        "ctrl+alt+left=goto_split:left"
        "ctrl+alt+right=goto_split:right"
        "ctrl+alt+up=goto_split:up"
        "ctrl+alt+down=goto_split:down"

        # Shell command-line navigation
        "alt+left=esc:b"
        "alt+right=esc:f"
        "alt+d=esc:d"      

        # Close currently focused split
        "ctrl+shift+w=close_surface"
      ];
 
      # Better compatibility when SSHing to HPC/remote systems.
      "shell-integration-features" =
        "ssh-env,ssh-terminfo,sudo";
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

    settings = {
      user = {
        name = "EStroiu";
        email = "e.stroiu@vu.nl";
      };
    };
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
    
    # File editors
    kdePackages.kate
    joplin-desktop
  ];
}
