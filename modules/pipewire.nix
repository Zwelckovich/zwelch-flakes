{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    alsa-lib
    alsa-utils
    flac
    pulsemixer
  ];

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };
}
