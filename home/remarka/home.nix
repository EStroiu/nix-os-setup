{ pkgs, ... }:

{
  home.username = "remarka";
  home.homeDirectory = "/home/remarka";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

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
