# suraj@evenzero
# nixOS Config
{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # - BOOTLOADER -
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [
      "usb_storage"
      "usbhid"
      "mtp"
      "libusb"
    ];
  };

  # - NETWORKING -
  networking = {
    hostName = "nixos";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd"; # Use iwd as backend
    };
    wireless.iwd.enable = true; #inet wireless daemon
  };

  # - XDG portal config for Wayland -
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        kdePackages.xdg-desktop-portal-kde # For Plasma sessions
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      # Explicit portal configuration to prevent conflicts
    };

    # Add this to your configuration.nix or home.nix
    mime.defaultApplications = {
      "inode/directory" = "thunar.desktop";
      "application/x-gnome-saved-search" = "thunar.desktop";

      "text/html" = "firefox.desktop";

      # URL scheme handlers
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };

  # - USERS -
  users.users.suraj = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "suraj";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "video"
      "input"
      "adbusers"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # - SERVICES -
  time.timeZone = "Asia/Kolkata";

  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
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
  };

  services = {
    logind = {
      lidSwitch = "suspend";
    };

    udev.extraRules = ''
      # Google
      SUBSYSTEM=="usb", ATTR{idVendor}=="18d1", MODE="0666", GROUP="adbusers"
      # Samsung
      SUBSYSTEM=="usb", ATTR{idVendor}=="04e8", MODE="0666", GROUP="adbusers"
      # OnePlus
      SUBSYSTEM=="usb", ATTR{idVendor}=="2a70", MODE="0666", GROUP="adbusers"
      # POCO
      SUBSYSTEM=="usb", ATTR{idVendor}=="1d6b", MODE="0666", GROUP="plugdev"
    '';

    # Enable thumbnail support
    tumbler.enable = true;

    # X11 server (needed for apps that still use Xwayland)
    xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
      # keyboard layout
      xkb = {
        layout = "us";
        variant = "";
      };
    };

    # dbus
    dbus.enable = true;

    # display manager
    displayManager = {
      ly = {
        enable = true;
        settings = {
          animation = "matrix";
          bigclock = true;
        };
      };
      autoLogin = {
        enable = false;
        user = "suraj";
      };
    };

    # plasma is optional, disable if you want pure sway
    desktopManager.plasma6 = {
      enable = false;
      enableQt5Integration = true;
    };

    # flatpack
    flatpak.enable = true;

    # printers
    printing.enable = true;

    # pipewire for sound
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };

    # Add gnome-keyring for secret management in Sway
    gnome.gnome-keyring.enable = true;

    gvfs.enable = true;
    udisks2.enable = true; # required for device mounting
  };

  # bluetooth
  hardware.bluetooth.enable = true;

  # - ENVIRONMENT -
  # environment variables specifically for Sway session
  environment = {
    sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "sway";
      GTK_THEME = "Adwaita:dark";
    };

    # packages
    systemPackages = with pkgs; [
      # utils
      wget
      neofetch
      pkgs.lsyncd

      ripgrep
      fd

      # code
      git
      neovim
      wezterm

      #languages
      nodejs_20
      python3
      go
      rustc
      cargo
      jdk
      perl
      ruby
      bundler
      jekyll

      # build systems
      gradle

      cmake
      gnumake
      automake
      ninja

      #c/c++
      bison
      flex
      clang
      gcc
      vcpkg
      autoconf
      cacert
      libtool
      pkg-config
      gettext # for autopoint
      m4
      lazygit
      lazydocker
      docker

      #lsp
      stylua
      lua-language-server
      clang-tools # includes clangd (and other extras, formatter)
      rust-analyzer
      rustfmt

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
      swayidle
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

      xfce.thunar
      xfce.thunar-volman # for removable media
      xfce.thunar-archive-plugin # for archive support

      gvfs # mount backend

      # GTK theme packages (choose your preferred theme)
      adwaita-qt
      libsForQt5.qtstyleplugin-kvantum
      phinger-cursors

      android-tools
      mtpfs # for file transfers via MTP
    ];

    # mako configuration directory and file
    etc = {
      # mako notification style
      "xdg/mako/config" = {
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

      # Alternative: Create a Sway config snippet that you can include
      "sway/mako.conf" = {
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

      # create test notification script
      "sway/test-notifications.sh" = {
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
    };
  };

  # - PROGRAMS -
  programs = {
    sway.enable = true; # enable sway
    firefox.enable = true; # enable firefox
    zsh.enable = true;
    gtklock.enable = true;

    # enable GTK theming system-wide
    dconf.enable = true;
  };

  # - SECURITY -
  security = {
    pam.services = {
      gtklock = {};
      sddm.enableGnomeKeyring = true;
    };
    polkit.enable = true;
    rtkit.enable = true;
  };

  # - EVERYTHING ELSE -
  # Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      kdePackages =
        pkgs.kdePackages
        // {
          dolphin = pkgs.runCommand "dolphin-disabled" {} "mkdir $out";
        };
    };
  };

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
