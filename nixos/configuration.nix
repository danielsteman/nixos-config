# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
    ./python.nix
  ];

  time.timeZone = "Europe/Amsterdam";

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  fonts.fonts = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
    meslo-lgs-nf
  ];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking.hostName = "mothership";

  # Bootloader settings
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.loader.grub.configurationLimit = 10;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    daniel = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "saberone";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [
        "wheel" 
        "docker" 
        "audio"
        "jackaudio"
      ];
      shell = pkgs.zsh;
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    # Forbid root login through SSH.
    permitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    passwordAuthentication = false;
  };

  services.udev.extraRules = "ACTION=='add', SUBSYSTEM=='usb' DRIVER=='usb', ATTR{power/wakeup}='enabled'";

  # Get i3 to work
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      session = [
        {
          name = "home-manager";
          start = ''
            $(pkgs.runtimeShell) $HOME/.hm-xsession &
            waitPID=$!
          '';
        }
      ];
    };
    displayManager = {
      defaultSession = "none+i3";
    };
    windowManager.i3 = {
      package = pkgs.i3-gaps;
      enable = true;
    };
    dpi = 175;
    videoDrivers = [ "nvidia" ];
  };

  environment.systemPackages = with pkgs; [
    efibootmgr
    gcc
    rustc
    nodejs-18_x
    yarn
    cargo
    zsh
    tree
    unzip
    wget
    stow
    pulseaudioFull
    lsof
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";

  sound.enable = true;

  nixpkgs.config.pulseaudio = true;

  services.jack = {
    jackd.enable = true;
    # support ALSA only programs via ALSA JACK PCM plugin
    alsa.enable = false;
    # support ALSA only programs via loopback device (supports programs like Steam)
    loopback = {
      enable = true;
      # buffering parameters for dmix device to work with ALSA only semi-professional sound programs
      #dmixConfig = ''
      #  period_size 2048
      #'';
    };
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  hardware.pulseaudio.enable = false;

}
