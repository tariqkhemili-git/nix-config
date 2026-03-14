{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "hypr-ocr" ''
      # Explicitly pull dependencies from the Nix store
      export PATH="${pkgs.lib.makeBinPath [ 
        pkgs.grim 
        pkgs.slurp 
        pkgs.tesseract 
        pkgs.wl-clipboard 
        pkgs.libnotify 
        pkgs.coreutils 
      ]}:$PATH"

      IMAGE_PATH="/tmp/ocr_capture.png"

      # Select region and capture
      if grim -g "$(slurp)" "$IMAGE_PATH"; then
        # Process OCR locally - no data leaves your machine
        tesseract "$IMAGE_PATH" - stdout quiet | wl-copy
        notify-send "OCR Complete" "Text copied to clipboard."
        rm "$IMAGE_PATH"
      else
        notify-send "OCR Cancelled" "No area selected."
      fi
    '')
  ];
}
