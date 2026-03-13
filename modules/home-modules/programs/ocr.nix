{ pkgs, ... }:

{
  home.packages = with pkgs; [
    jq # Required for parsing the JSON response from Ollama
    
    (pkgs.writeScriptBin "hypr-ocr" ''
      #!/usr/bin/env fish

      # 1. Define paths - using /tmp ensures it never touches persistent storage
      set temp_name "hypr_ocr_"(random)".png"
      set temp_img "/tmp/$temp_name"

      # 2. Capture the region
      # -m region: select area | -o: output dir | -f: filename | -s: silent mode
      hyprshot -m region -o /tmp -f $temp_name -s

      # 3. Exit if the user cancelled the screenshot (file won't exist)
      if not test -f $temp_img
          exit 0
      end

      # 4. Notify user that local processing has started
      notify-send -t 2000 "OCR Started" "Analysing securely on device..."

      # 5. Base64 encode the image for the Ollama API
      set img_b64 (base64 -w 0 $temp_img)
      
      # 6. Request OCR from local Ollama instance (forcing IPv4 loopback)
      set ocr_response (curl -s --connect-timeout 10 http://127.0.0.1:11434/api/generate -d "{
        \"model\": \"glm-ocr:bf16\",
        \"prompt\": \"Extract all text from this image. Output only the exact text seen, without any formatting or conversational filler.\",
        \"images\": [\"$img_b64\"],
        \"stream\": false
      }")

      # 7. Check for connection/API errors
      if test $status -ne 0
          notify-send -u critical -t 4000 "OCR Error" "Could not connect to Ollama. Ensure 'systemctl status ollama' is active."
          rm -f $temp_img
          exit 1
      end

      # 8. Parse the text result using jq
      set ocr_text (echo $ocr_response | jq -r '.response // empty')

      # 9. Handle results and clean up
      if test -z "$ocr_text" -o "$ocr_text" = "null"
          notify-send -u critical -t 3000 "OCR Failed" "No text detected in the selection."
      else
          echo -n "$ocr_text" | wl-copy
          notify-send -t 3000 "OCR Complete" "Text securely copied to clipboard."
      end

      # 10. Securely delete the temporary file immediately
      rm -f $temp_img
    '')
  ];
}
