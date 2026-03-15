{ ... }:

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
      # Standard Parallel Sync (Copy)
      copy = "fpsync -n 20 -o '-aWq'";
      # Parallel Move (Delete source after successful transfer)
      move = "fpsync -n 20 -o '-aWq --remove-source-files'";
      # Parallel Merge (Only copy newer files)
      merge = "fpsync -n 20 -o '-aWqu'";
      dl-sc = "yt-dlp --config-location ~/.config/yt-dlp/soundcloud.conf";
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
  };
}
