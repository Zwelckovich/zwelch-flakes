{ pkgs, ... }:

{
  fonts = {
    #enableDefaultPackages = false;

    packages = with pkgs; [
      noto-fonts
      nerdfonts
    ];
  };
}
