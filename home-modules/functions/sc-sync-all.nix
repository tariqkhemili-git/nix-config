{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "sc-sync-all" ''
      list_path="/home/light/Documents/Music/music_list.txt"

      if [ -f "$list_path" ]; then
        echo "Syncing tracks from $list_path..."
        # Spoofing User-Agent to blend in and minimize fingerprinting
        ${pkgs.yt-dlp}/bin/yt-dlp \
          --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36" \
          -a "$list_path" "$@"
      else
        echo "Error: music_list.txt not found at $list_path"
        echo "Opening folder for you..."
        # Fallback to your primary file manager
        ${pkgs.kdePackages.dolphin}/bin/dolphin "$(dirname "$list_path")"
      fi
    '')
  ];
}
