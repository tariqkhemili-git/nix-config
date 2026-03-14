#!/usr/bin/env bash

output_file="/home/light/Documents/System Info/system-report.md"
timestamp=$(date "+%Y-%m-%d %H:%M:%S")

echo "Gathering system data... This may take a moment and prompt for sudo."

# Initialise the file and write the header
echo "# System Snapshot Report" > "$output_file"
echo "**Generated:** $timestamp" >> "$output_file"
echo "" >> "$output_file"

echo "## 1. Hardware Overview (inxi)" >> "$output_file"
echo '```text' >> "$output_file"
nix run nixpkgs#inxi -- -Fxxxrz -c 0 >> "$output_file"
echo '```' >> "$output_file"
echo "" >> "$output_file"

echo "## 2. Detailed Hardware (lshw)" >> "$output_file"
echo "Contains granular component UUIDs, serial numbers, and VRAM sizing." >> "$output_file"
echo '```json' >> "$output_file"
sudo nix run nixpkgs#lshw -- -json >> "$output_file"
echo '```' >> "$output_file"
echo "" >> "$output_file"

echo "## 3. Storage and Block Devices" >> "$output_file"
echo '```json' >> "$output_file"
nix run nixpkgs#lsblk -- -J -o NAME,MODEL,SERIAL,SIZE,UUID,FSTYPE,MOUNTPOINT >> "$output_file"
echo '```' >> "$output_file"
echo "" >> "$output_file"

echo "## 4. Sensor Data" >> "$output_file"
echo '```json' >> "$output_file"
nix run nixpkgs#lm_sensors -- sensors -j >> "$output_file"
echo '```' >> "$output_file"
echo "" >> "$output_file"

echo "## 5. Hyprland Monitors" >> "$output_file"
echo '```json' >> "$output_file"
hyprctl monitors all -j >> "$output_file"
echo '```' >> "$output_file"
echo "" >> "$output_file"

echo "## 6. Flake Metadata" >> "$output_file"
echo '```text' >> "$output_file"
nix flake metadata ~/.nix >> "$output_file"
echo '```' >> "$output_file"
echo "" >> "$output_file"

echo "## 7. Full System Dependencies" >> "$output_file"
echo "<details><summary>Click to expand full Nix store closure</summary>" >> "$output_file"
echo "" >> "$output_file"
echo '```text' >> "$output_file"
nix-store --query --requisites /run/current-system >> "$output_file"
echo '```' >> "$output_file"
echo "</details>" >> "$output_file"

echo -e "\nSnapshot complete!\nMarkdown report saved locally to:\n$output_file"
