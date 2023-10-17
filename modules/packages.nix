{ pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    brave
    neofetch
    eza
  ];
}
