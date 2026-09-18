{ pkgs, ... }:

{
  programs.niri.enable = true;

  # When Niri is launched through greetd/niri-session,
  # let it inherit the complete user environment/PATH.
  systemd.user.services.niri.enableDefaultPath = false;

  # Authorization prompts.
  security.polkit.enable = true;

  # Secret/keyring service for desktop applications.
  services.gnome.gnome-keyring.enable = true;

  # X11 compatibility for applications that do not support Wayland.
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
