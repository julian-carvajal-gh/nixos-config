{
  config,
  pkgs,
  lib,
  ...
}: {
  home.username = "julianc";
  home.homeDirectory = "/home/julianc";

  home.packages = with pkgs; [
    # Utility
    ripgrep # Recursively searches directories for a regex pattern
    eza # A modern replacement for ‘ls’
    fzf # A command-line fuzzy finder
    fastfetch # Pretty system summary
    just # Command runner

    # nix related
    alejandra # Formatter for Nix code

    # GNOME extensions
    gnomeExtensions.caffeine
    gnomeExtensions.appindicator
    gnomeExtensions.blur-my-shell

    # Office
    libreoffice
    pdfarranger

    # Communication
    zoom-us
    signal-desktop

    # Graphics
    gimp3
    inkscape

    # Audio & Video
    audacity
    vlc
    pitivi

    # Games
    steam
    prismlauncher

    # Privacy
    bitwarden-desktop

    # Networking
    aircrack-ng # WiFi security auditing
    nmap # Network discovery
    tor-browser
  ];

  # Git
  programs.git = {
    enable = true;
    settings = {
      user.name = "Julian Carvajal";
      user.email = "julian@jcarvajal.com";
      init.defaultBranch = "main";
    };
    signing = {
      format = "openpgp";
      key = "75465CDBAC806387";
      signByDefault = true;
    };
  };

  # Starship shell prompt
  programs.starship = {
    enable = true;
  };

  # Bash
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin"
    '';

    shellAliases = {
      ls = "eza";
    };
  };

  # Compatible release. See new release notes before changing.
  home.stateVersion = "25.05";
}
