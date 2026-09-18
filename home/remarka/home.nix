{ pkgs, ... }:

{
  home.username = "remarka";
  home.homeDirectory = "/home/remarka";

  # Like system.stateVersion, don't change this later just because
  # you upgrade Home Manager/NixOS.
  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  programs.bash = {
    enable = true;

    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
    };
  };

  home.packages = with pkgs; [
    fastfetch
  ];
}
