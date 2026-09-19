{ config, pkgs, ... }:

{
  # Lightweight login manager.
  #
  # tuigreet handles authentication and then starts Niri.
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --asterisks --cmd ${config.programs.niri.package}/bin/niri-session";
        user = "greeter";
      };
    };
  };

  # Power and Battery
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Printing.
  services.printing.enable = true;

  # Audio.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Browser.
  programs.firefox.enable = true;
}
