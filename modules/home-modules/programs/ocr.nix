{ pkgs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.writeScriptBin "hypr-ocr" ''
      #!/usr/bin/env fish
      # Generate a random temporary filename
      set temp_img "/tmp/hypr_ocr_"(random)".png"

      # Capture region silently (-s) and save to the temporary file
      hyprshot -m region -o /tmp -f (basename $temp_img) -s

      # Exit cleanly if you cancel the selection (no file created)
      if not test -f $temp_img
          exit 0
      end

      notify-send -t 2000 "OCR Started" "Analysing securely on device..."

      # Encode image to base64 for the Ollama API
      set img_b64 (base64 -w 0 $temp_img)

      # Call the local Ollama API
      set ocr_response (curl -s http://localhost:11434/api/generate -d '{
        "model": "glm-ocr:bf16",
        "prompt": "Extract all text from this image. Output only the exact text seen, without any formatting, tags, or conversational filler.",
        "images": ["'$img_b64'"],
        "stream": false
      }')

      # Check if the curl command failed (e.g., Ollama is offline)
      if test $status -ne 0
          notify-send -u critical -t 3000 "OCR Error" "Could not connect to local Ollama instance."
          rm -f $temp_img
          exit 1
      end

      # Extract the text securely
      set ocr_text (echo $ocr_response | jq -r '.response // empty')

      # Handle the result
      if test -z "$ocr_text"
          notify-send -u critical -t 3000 "OCR Failed" "No text detected."
      else
          echo -n "$ocr_text" | wl-copy
          notify-send -t 3000 "OCR Complete" "Text securely copied to clipboard."
      end

      # Instantly purge the temporary screenshot
      rm -f $temp_img
    '')
  ];
}
