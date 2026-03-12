{ ... }:

{
  networking = {
    hostName = "nixterminator";
    networkmanager = {
      enable = true;
      wifi = {
        scanRandMacAddress = true; # Moved from dot notation into the tree
      };
    };

    # Privacy-focused DNS (Quad9) to bypass UK ISP filtering [cite: 15]
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];
    # Firewall Configuration [cite: 16]
    firewall = {
      enable = true;
      # Syncthing ports: 22000 (TCP/UDP) for sync, 21027 (UDP) for discovery [cite: 17]
      # Only allow these if you are syncing with your Pixel 10 Pro (GrapheneOS)
      # allowedTCPPorts = [ 22000 ];
      # allowedUDPPorts = [ 22000 21027 ];
    };
  };
}
