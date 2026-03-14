#!/usr/bin/env bash

# 1. Define paths - /tmp is RAM-backed, ensuring no persistent disk writes
base_name="hypr_ocr_$RANDOM"
temp_img="/tmp/$base_name.png"
temp_json="/tmp/$base_name.json"

# 2. Capture the region silently
hyprshot -m region -o /tmp -f "$base_name.png" -s

# 3. Return cleanly if the user cancelled the screenshot
if [ ! -f "$temp_img" ]; then
    exit 0
fi

# 4. Notify user
notify-send -t 2000 "OCR Started" "Analysing securely on device..."

# 5. Base64 encode the image
img_b64=$(base64 -w 0 "$temp_img")

# 6. Safely construct the JSON payload to avoid command-line length limits
jq -n --arg img "$img_b64" '{
  "model": "glm-ocr:bf16",
  "prompt": "Extract all text from this image. Output only the exact text seen, without any formatting or conversational filler.",
  "images": [$img],
  "stream": false
}' > "$temp_json"

# 7. Request OCR, reading the payload directly from the temporary JSON file
ocr_response=$(curl -s --connect-timeout 10 http://127.0.0.1:11434/api/generate -H "Content-Type: application/json" -d @"$temp_json")

# 8. Check for connection/API errors
if [ $? -ne 0 ]; then
    notify-send -u critical -t 4000 "OCR Error" "Could not connect to Ollama. Ensure 'systemctl status ollama' is active."
    rm -f "$temp_img" "$temp_json"
    exit 1
fi

# 9. Parse the text result
ocr_text=$(echo "$ocr_response" | jq -r '.response // empty')

# 10. Handle results and display output
if [ -z "$ocr_text" ] || [ "$ocr_text" = "null" ]; then
    notify-send -u critical -t 3000 "OCR Failed" "No text detected in the selection."
else
    echo -n "$ocr_text" | wl-copy
    notify-send -t 5000 "OCR Complete" "Text copied to clipboard."
fi

# 11. Cleanup
rm -f "$temp_img" "$temp_json"