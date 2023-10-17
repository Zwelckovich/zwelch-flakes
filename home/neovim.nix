{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # nix
    nil
    nixpkgs-fmt
  ];
}
