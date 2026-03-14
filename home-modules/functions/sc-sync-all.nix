{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "sc-sync-all" ''
      list_path="/home/light/Documents/Music/music_list.txt"
      cookies_path="/home/light/Documents/Music/soundcloud.com_cookies.txt"

      if [ -f "$list_path" ]; then
        echo "Syncing tracks from $list_path using cookies..."
        # Slow down requests and spoof User-Agent to prevent 403 blocks and minimise tracking
        ${pkgs.yt-dlp}/bin/yt-dlp \
          --cookies "$cookies_path" \
          --sleep-requests 2 \
          --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" \
          -a "$list_path" "$@"
      else
        echo "Error: music_list.txt not found at $list_path"
        echo "Opening folder for you..."
        # Launches your primary file manager directly since Fish aliases won't work in a Bash script
        ${pkgs.kdePackages.dolphin}/bin/dolphin "$(dirname "$list_path")"
      fi
    '')
  ];
}
