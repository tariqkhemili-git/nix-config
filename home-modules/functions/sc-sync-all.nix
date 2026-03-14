{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "sc-sync-all" ''
      list_path="/home/light/Documents/Music/music_list.txt"

      if [ -f "$list_path" ]; then
        echo "Syncing tracks with enhanced stealth and Cloudflare DNS..."
        # --referer: Makes it look like you're clicking through from the SoundCloud site
        # --geo-bypass: Helps circumvent regional blocks
        # --add-header: Adds standard browser headers to look more "human"
        ${pkgs.yt-dlp}/bin/yt-dlp \
          --rm-cache-dir \
          --force-ipv4 \
          --sleep-requests 1.5 \
          --geo-bypass \
          --referer "https://soundcloud.com/" \
          --add-header "Accept-Language: en-GB,en;q=0.9" \
          --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" \
          -a "$list_path" "$@"
      else
        echo "Error: music_list.txt not found at $list_path"
        echo "Opening folder..."
        ${pkgs.kdePackages.dolphin}/bin/dolphin "$(dirname "$list_path")"
      fi
    '')
  ];
}
