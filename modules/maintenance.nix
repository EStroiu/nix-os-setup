{ ... }:

{
  # Garbage collect old generations and unused store paths.
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";

    # If the laptop was off when GC was scheduled,
    # run it after the next boot.
    persistent = true;

    # Avoid always doing maintenance at exactly the same moment.
    randomizedDelaySec = "45min";
  };

  # Deduplicate identical files in /nix/store.
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
    randomizedDelaySec = "45min";
  };
}
