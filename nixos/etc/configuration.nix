{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # - BOOTLOADER -
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # - NETWORKING -
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # - XDG portal config for Wayland -
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde # For Plasma sessions
    ];
    # Explicit portal configuration to prevent conflicts
  };

  # - USERS -
  users.users.suraj = {
    isNormalUser = true;
    description = "suraj";
    extraGroups = ["networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # - SERVICES -
  time.timeZone = "Asia/Kolkata";

  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  # X11 server (needed for apps that still use Xwayland)
  services.xserver.enable = true;

  # display manager
  services.displayManager.sddm.enable = true;
  services.displayManager.autoLogin.enable = false;
  services.displayManager.autoLogin.user = "suraj";

  # plasma is optional, disable if you want pure sway
  services.desktopManager.plasma6.enable = true;

  # flatpack
  services.flatpak.enable = true;

  # keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # printers
  services.printing.enable = true;

  # pipewire for sound
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Add gnome-keyring for secret management in Sway
  services.gnome.gnome-keyring.enable = true;

  # - ENVIRONMENT -
  # environment variables specifically for Sway session
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
  };

  # packages
  environment.systemPackages = with pkgs; [
    wget
    neofetch
    git
    nodejs_20
    python3
    docker
    wezterm
    go
    rustc
    cargo
    neovim
    gcc
    gnumake
    cmake
    pkg-config
    ruby
    bundler
    jekyll
    ripgrep
    fd
    lazygit
    lazydocker

    pkgs.ghostty
    pkgs.sxiv

    # screenshot system
    grim
    slurp
    wl-clipboard
    sway-contrib.grimshot
    swappy

    # notification system
    libnotify

    # Sway ecosystem
    sway # the WM
    waybar # status bar
    wofi # launcher
    mako # notifications
    wl-clipboard # clipboard utils
    grim # screenshot
    slurp # region selection
    brightnessctl # brightness control
    playerctl # media control
    wdisplays # display config GUI
    wlr-randr # CLI display config
    kanshi # auto display profiles
    cliphist # clipboard history
    networkmanagerapplet
    blueman
    pavucontrol

    foliate # book reader
  ];

  # mako configuration directory and file
  environment.etc."xdg/mako/config" = {
    text = ''
      # Mako configuration

      # Basic settings
      max-history=100
      sort=-time

      # Appearance
      background-color=#1e1e2e
      text-color=#cdd6f4
      border-color=#89b4fa
      progress-color=over #74c7ec

      # Border and shape
      border-size=2
      border-radius=8

      # Typography
      font=monospace 11

      # Layout
      width=380
      height=100
      margin=10
      padding=15

      # Position (top-right corner)
      anchor=top-right

      # Timing
      default-timeout=4000
      ignore-timeout=0

      # Grouping
      group-by=app-name
      max-visible=5

      # Icons
      icons=1
      max-icon-size=48
      icon-path=/run/current-system/sw/share/icons/Papirus-Dark

      # Interaction
      on-button-left=dismiss
      on-button-middle=none
      on-button-right=dismiss-all
      on-touch=dismiss

      # Sound (optional - disable if you don't want notification sounds)
      # on-notify=exec mpv /usr/share/sounds/freedesktop/stereo/message-new-instant.oga

      # Application-specific overrides
      [app-name="Volume"]
      border-color=#a6e3a1
      default-timeout=2000
      group-by=none

      [app-name="Brightness"]
      border-color=#f9e2af
      default-timeout=2000
      group-by=none

      [urgency=critical]
      background-color=#f38ba8
      text-color=#1e1e2e
      border-color=#f38ba8
      default-timeout=0
      ignore-timeout=1

      [urgency=high]
      background-color=#fab387
      text-color=#1e1e2e
      border-color=#fab387
      default-timeout=8000

      [urgency=low]
      background-color=#313244
      default-timeout=2000
    '';
    mode = "0644";
  };

  # create a system-wide .desktop for sxiv
  environment.etc."xdg/desktop-directories/sxiv.desktop".text = ''
    [Desktop Entry]
    Name=sxiv
    Comment=Simple X Image Viewer
    Exec=sxiv %F
    Icon=image-x-generic
    Type=Application
    Categories=Graphics;Viewer;
    MimeType=image/bmp;image/gif;image/jpeg;image/png;image/tiff;
  '';

  # Alternative: Create a Sway config snippet that you can include
  environment.etc."sway/mako.conf" = {
    text = ''
      # Mako configuration for Sway
      # Add this to your ~/.config/sway/config: include /etc/sway/mako.conf

      # Start Mako notification daemon
      exec mako --config /etc/xdg/mako/config

      # Notification control bindings
      bindsym $mod+n exec makoctl dismiss
      bindsym $mod+Shift+n exec makoctl dismiss --all
      bindsym $mod+Control+n exec makoctl restore
      bindsym $mod+Alt+n exec makoctl menu wofi --show dmenu
    '';
    mode = "0644";
  };

  # 4. Create test notification script
  environment.etc."sway/test-notifications.sh" = {
    text = ''
      #!/usr/bin/env bash

      echo "Testing Mako notifications..."

      # Test basic notification
      notify-send "Test" "Basic notification"
      sleep 2

      # Test with icon
      notify-send -i "dialog-information" "Information" "This is an info notification"
      sleep 2

      # Test urgency levels
      notify-send -u low "Low Priority" "This is a low priority message"
      sleep 2
      notify-send -u normal "Normal Priority" "This is a normal message"
      sleep 2
      notify-send -u critical "Critical!" "This is critical and won't disappear automatically"
      sleep 2

      # Test with progress bar
      notify-send -h int:value:75 "Progress" "Task 75% complete"
      sleep 2

      # Test app-specific styling
      notify-send -a "Volume" "Volume Test" "Testing volume-specific styling"
      sleep 2

      # Test with actions (if supported)
      notify-send -a "Test App" "Action Test" "Click to dismiss" --action="dismiss=Dismiss"

      echo "Notification tests complete!"
    '';
    mode = "0755";
  };
  # - PROGRAMS -
  programs.sway.enable = true; # enable sway
  programs.firefox.enable = true; # enable firefox

  # - SECURITY -
  security.polkit.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;
  security.rtkit.enable = true;

  # - EVERYTHING ELSE -
  # Flakes
  nix.settings.experimental-features = ["nix-command" "flakes"];
  nixpkgs.config.allowUnfree = true;

  # Virtu/Docker
  virtualisation.docker.enable = true;
  system.stateVersion = "25.05";

  # Fonts
  fonts = {
    packages = with pkgs; [
      (pkgs.stdenv.mkDerivation {
        name = "custom-fonts";
        src = ./fonts;
        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          cp *.ttf $out/share/fonts/truetype/
        '';
      })
    ];
    fontconfig.enable = true;
  };
}
