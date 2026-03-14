{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "hypr-ocr" ''
      # Inject dependencies directly into the script's PATH
      export PATH="${pkgs.lib.makeBinPath [ pkgs.grim pkgs.slurp pkgs.tesseract pkgs.wl-clipboard pkgs.libnotify pkgs.coreutils ]}:$PATH"

      # --- Paste your hypr-ocr.sh bash logic below ---
      # Ensure you call commands natively (e.g., 'grim', 'tesseract') without 'nix run'.
      
      IMAGE_PATH="/tmp/ocr_image_$(date +%s).png"
      
      # Capture region
      if grim -g "$(slurp)" "$IMAGE_PATH"; then
        # Perform OCR and pipe to Wayland clipboard
        tesseract "$IMAGE_PATH" - stdout quiet | wl-copy
        notify-send "Privacy OCR" "Text processed locally and copied to clipboard."
      else
        notify-send "Privacy OCR" "Capture cancelled."
      fi
      
      # Securely clean up the temporary image
      rm -f "$IMAGE_PATH"
    '')
  ];
}
