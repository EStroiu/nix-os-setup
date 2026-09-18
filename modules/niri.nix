{ pkgs, ... }:

{
  # Enable the Niri Wayland compositor.
  programs.niri.enable = true;

  # Authorization dialogs used by desktop applications.
  security.polkit.enable = true;

  # Secret/keyring service.
  services.gnome.gnome-keyring.enable = true;

  hardware.bluetooth.enable = true;

  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Needed for older X11 applications and games.
  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
