{ ... }:

{
  # Declaratively create a specific config profile for SoundCloud
  xdg.configFile."yt-dlp/soundcloud.conf".text = ''
    # --- STORAGE ---
    --paths "/home/light/Music"
    --output "%(uploader)s/%(title)s.%(ext)s"

    # --- AUDIO QUALITY ---
    --extract-audio
    --audio-format mp3
    --audio-quality 0

    # --- METADATA & VISUALS ---
    --embed-metadata
    --embed-thumbnail

    # --- SYSTEM & SYNC ---
    --mtime
    --ignore-errors

    # --- PERFORMANCE (NATIVE) ---
    --concurrent-fragments 16

    # --- ANTI-BLOCKING ---
    --user-agent "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
  '';
}
