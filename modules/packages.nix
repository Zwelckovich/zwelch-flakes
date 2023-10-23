{ pkgs, lib, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz)
    # reuse the current configuration
    { config = config.nixpkgs.config; };
in
{
  environment.systemPackages = with pkgs; [
    brave
    neofetch
    unstable.eza
  ];
}
