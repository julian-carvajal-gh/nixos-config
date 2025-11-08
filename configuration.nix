# Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’)
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan
    ./hardware-configuration.nix

    # Framework 13 (AMD) options
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Define your hostname
  networking.hostName = "julianc-fw";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone
  time.timeZone = "America/New_York";

  # Select internationalisation properties
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the GNOME Desktop Environment
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  services.gnome.core-developer-tools.enable = true;

  # GSettings Overrides
  services.desktopManager.gnome = {
    extraGSettingsOverrides = ''
      # Favorite apps in gnome-shell
      [org.gnome.shell]
      favorite-apps=['org.gnome.Nautilus.desktop', 'org.gnome.Console.desktop', 'org.gnome.TextEditor']

      # Enable fractional scaling
      [org.gnome.mutter]
      experimental-features=['scale-monitor-framebuffer']
    '';

    extraGSettingsOverridePackages = [
      pkgs.gnome-shell # for org.gnome.shell
      pkgs.mutter # for org.gnome.mutter
    ];
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’
  users.users.julianc = {
    isNormalUser = true;
    description = "Julian Carvajal";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # Enable automatic login for the user
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "julianc";

  # Workaround for GNOME autologin:
  # https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # System packages
  environment.systemPackages = with pkgs; [
    vim
    firefox
    chromium
  ];

  programs.gnupg.agent.enable = true;

  # Services
  services.flatpak.enable = true;

  # Allow unfree software :(
  nixpkgs.config.allowUnfree = true;

  # Automatic system upgrades
  system.autoUpgrade = {
    enable = true;
    flake = inputs.self.outPath;
    flags = ["--print-build-logs"];
    dates = "18:00";
  };

  # Periodically optimise the store
  nix.settings.auto-optimise-store = true;

  # Garbage collect old generations and limit how many to keep
  boot.loader.systemd-boot.configurationLimit = 10;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # Enable Flakes and the new accompanying CLI tool
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
