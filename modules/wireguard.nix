{ pkgs, ... }:

{
  # NetworkManager already handles the WireGuard connection itself.
  # This gives us the `wg` command for inspection/troubleshooting.
  environment.systemPackages = with pkgs; [
    wireguard-tools
  ];
}
