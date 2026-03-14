{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "system-report" ''
      # Inject hardware utilities safely into the script's PATH
      export PATH="${
        pkgs.lib.makeBinPath [
          pkgs.util-linux
          pkgs.lm_sensors
          pkgs.pciutils
          pkgs.coreutils
        ]
      }:$PATH"

      # --- Paste your system-report.sh bash logic below ---
      # IMPORTANT FIX: Change 'nix run nixpkgs#lsblk' to simply 'lsblk'
      # IMPORTANT FIX: Change 'nix run nixpkgs#sensors' to simply 'sensors'

      echo "=== Storage Devices ==="
      lsblk

      echo -e "\n=== Hardware Temperatures ==="
      sensors
    '')
  ];
}
