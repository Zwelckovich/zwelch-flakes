{ pkgs, ... }:

{
  programs = {
    hyprland = {
      enable = true;

      xwayland = {
        enable = true;
      };
      enableNvidiaPatches = false;
    };
  };

  services = {
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = true;
      };

      displayManager = {
        defaultSession = "hyprland";
        lightdm.enable = false;
        sddm = {
          enable = true;
        };
      };
    };
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBREDER = "1";

    # NVIDIA
    # LIBVA_DRIVER_NAME = "nvidia";
    # XDG_SESSION_TYPE = "wayland";
    # GBM_BACKEND = "nvidia-drm";
    # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    WLR_NO_HARDWARE_CURSORS = "1";
    # WLR_EGL_NO_MODIFIERS = "1";
  };

  hardware = {
    opengl.enable = true;
  };
}
