{ ... }:

{
  services.openssh = {
    enable = true;

    # Allow SSH through the NixOS firewall.
    openFirewall = true;

    settings = {
      # Never allow direct SSH login as root.
      PermitRootLogin = "no";
    };
  };
}
