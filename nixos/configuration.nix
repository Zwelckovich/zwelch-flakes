# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, lib
, config
, pkgs
, outputs
, ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration_changed.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users = {
      zwelch = import ../home;
    };
  };

  nixpkgs = {
    # You can add overlays here
    overlays = [
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

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
  console.keyMap = "de-latin1-nodeadkeys";
  i18n.defaultLocale = "de_DE.UTF-8";
  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking.hostName = "zwelchnix";

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.useOSProber = true;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    # FIXME: Replace with your username
    zwelch = {
      initialPassword = "pw";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        # TODO: Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" ];
    };
  };

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = false;
    # Forbid root login through SSH.
    settings.permitRootLogin = "no";
    # Use keys only. Remove if you want to SSH using password (not recommended)
    settings.passwordAuthentication = false;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.05";
}
