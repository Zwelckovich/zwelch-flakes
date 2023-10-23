{ pkgs, ... }:

{
   environment.systemPackages = with pkgs; [
      noto-fonts
      nerdfonts
    ];
}
