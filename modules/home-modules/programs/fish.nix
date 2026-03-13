{ pkgs, ... }:

{
  programs.fish = {
    enable = true;
    loginShellInit = ''
      if test (tty) = "/dev/tty1"
        exec start-hyprland
      end
    '';
    interactiveShellInit = ''
      set -g fish_greeting ""
      set -g fish_color_command green --bold
      set -g fish_color_keyword magenta
      set -g fish_color_quote yellow
      set -g fish_color_error red
      set -g fish_color_param blue
    '';

    shellAbbrs = {
      upd = "nh os switch -u ~/.nix";
      gitupd = ''z ~/.nix && git add . && git commit -m "" && git push -u origin main && nh os switch -u ~/.nix'';
      swi = "nh os switch ~/.nix";
      gitswi = ''z ~/.nix && git add . && git commit -m "" && git push -u origin main && nh os switch ~/.nix'';
      test = "nh os test ~/.nix";
      clean = "nh clean all";
      nixconf = "z ~/.nix && micro";
      s = "sudo";
      m = "micro";
      cd = "z";
      conf = "z ~/.nix";
      ".." = "z ..";
      # Rsync file operations (Optimised for local NVMe performance)
      copy = "rsync -aWq";
      move = "rsync -aWq --remove-source-files";
      merge = "rsync -aWqu";
    };

    shellAliases = {
      fish-edit = "micro /home/light/.nix/modules/home-modules/programs/fish.nix";
      nix-tree = "tree -J /home/light/.nix > '/home/light/Documents/System Info/nix-tree.json'";
      e = "micro";
      cat = "bat";
      ls = "eza --icons --group-directories-first";
      ll = "eza -lh --icons --grid --group-directories-first --sort=modified";
      # High-performance, multithreaded compression (silent)
      compress = "tar --use-compress-program='zstd -T0 -q' -cf";
      # Robust, format-agnostic, and silent extraction
      extract = "tar -xf";
    };

    functions = {
      "system-report" = {
        description = "Generate a full system and hardware snapshot ephemerally to a Markdown file";
        body = ''
          set -l output_file "/home/light/Documents/System Info/system-report.md"
          set -l timestamp (date "+%Y-%m-%d %H:%M:%S")

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
          # Fixed: Calling lsblk directly from the util-linux package
          nix run nixpkgs#lsblk -- -J -o NAME,MODEL,SERIAL,SIZE,UUID,FSTYPE,MOUNTPOINT >> "$output_file"
          echo '```' >> "$output_file"
          echo "" >> "$output_file"

          echo "## 4. Sensor Data" >> "$output_file"
          echo '```json' >> "$output_file"
          # Fixed: Using the correct package attribute for lm_sensors
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

          echo -e "\nSnapshot complete! Markdown report saved locally to:\n$output_file"
        '';
      };
    };
  };
}
