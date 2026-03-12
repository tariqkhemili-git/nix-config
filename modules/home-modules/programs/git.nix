{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    # Direct options for user identity
    userName = "Tariq Khemili";
    userEmail = "240774599+tariqkhemili-git@users.noreply.github.com";

    # Useful additions for a cleaner workflow
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;

      # Privacy: Prevent your local email from being leaked in certain logs
      core.quotepath = false;
    };

    # British English & Privacy: Ignore common junk files globally
    ignores = [
      "*.swp" # Micro/Vim swap files
      "result" # Nix build results [cite: 81]
      ".direnv/" # Development environment cache
      ".DS_Store" # macOS junk if you ever share files
      "*.secret" # Your custom secret pattern
    ];

    # Enhanced diffing
    delta = {
      enable = true;
      options = {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
        syntax-theme = "Nord"; # Matches a dark, clean aesthetic
      };
    };
  };
}
