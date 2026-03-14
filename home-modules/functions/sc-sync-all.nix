{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "sc-sync-all" ''
      list_path="/home/light/Documents/Music/music_list.txt"

      if [ -f "$list_path" ]; then
        echo "Syncing with Browser Impersonation and Jitter..."
        # --impersonate chrome: Mimics Chrome's TLS fingerprint to bypass WAFs
        # --sleep-requests 2: Adds a 2s base sleep
        # --sleep-interval 5 --max-sleep-interval 15: Adds random delays to look human
        ${pkgs.yt-dlp}/bin/yt-dlp \
          --rm-cache-dir \
          --force-ipv4 \
          --impersonate "chrome" \
          --sleep-requests 2 \
          --sleep-interval 5 \
          --max-sleep-interval 15 \
          --geo-bypass \
          --referer "https://soundcloud.com/" \
          -a "$list_path" "$@"
      else
        echo "Error: music_list.txt not found at $list_path"
        ${pkgs.kdePackages.dolphin}/bin/dolphin "$(dirname "$list_path")"
      fi
    '')
  ];
}
