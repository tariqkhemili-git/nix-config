{ pkgs, ... }:

{
  programs.git = {
    enable = true;

    # Modern structure: Identity and extra config merged into settings
    settings = {
      user = {
        name = "Tariq Khemili";
        email = "240774599+tariqkhemili-git@users.noreply.github.com";
      };

      # Useful additions for a cleaner workflow
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      push = {
        autoSetupRemote = true;
      };

      # Privacy: Prevent your local email/paths from being leaked in certain logs
      core = {
        quotepath = false;
      };
    };

    # British English & Privacy: Ignore common junk files globally
    ignores = [
      "*.swp" # Micro/Vim swap files
      "result" # Nix build results
      ".direnv/" # Development environment cache
      ".DS_Store" # macOS junk if you ever share files
      "*.secret" # Your custom secret pattern
    ];
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true; # Silences the deprecation warning
    options = {
      line-numbers = true;
      side-by-side = true;
    };
  };
}
