{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "system-report" ''
      # Ensure all required tools are available
      export PATH="${pkgs.lib.makeBinPath [ 
        pkgs.util-linux 
        pkgs.lm_sensors 
        pkgs.pciutils 
        pkgs.coreutils 
        pkgs.procps
      ]}:$PATH"

      REPORT_DIR="/home/light/Documents/System Info"
      REPORT_FILE="$REPORT_DIR/system-report.md"

      # Ensure directory exists (privacy: keeps info in your local Documents)
      mkdir -p "$REPORT_DIR"

      {
        echo "# System Report - $(date)"
        echo "## Storage (lsblk)"
        lsblk -p
        echo -e "\n## CPU Info"
        lscpu | head -n 20
        echo -e "\n## PCI Devices"
        lspci -vmm
        echo -e "\n## Memory & Uptime"
        uptime
        free -h
        echo -e "\n## Temperatures"
        sensors
      } > "$REPORT_FILE"

      notify-send "System Report" "Report generated at $REPORT_FILE"
    '')
  ];
}
