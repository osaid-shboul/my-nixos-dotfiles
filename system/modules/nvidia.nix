{ config, lib, pkgs, ... }:

{

  options.features.nvidia = {
    enable = lib.mkEnableOption "NVIDIA GPU drivers and CUDA support";
  };

  config = lib.mkIf config.features.nvidia.enable {
    
    services.xserver.videoDrivers = [ "nvidia" ];
    
    boot = {
      kernelParams = [
        "nvidia-drm.modeset=1"
        "nvidia.NVreg_PreserveVideoMemoryAllocations=1" 
      ];
      blacklistedKernelModules = [ "nouveau" ];
    };

    environment.variables = {
      LIBVA_DRIVER_NAME = "nvidia";
      XDG_SESSION_TYPE = "wayland";
      GBM_BACKEND = "nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
    };

    hardware = {
      nvidia = {
        open = false; 
        nvidiaSettings = true;
        modesetting.enable = true; 
        powerManagement.enable = true;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          nvidia-vaapi-driver
          libva-vdpau-driver
          libvdpau-va-gl
          mesa
          egl-wayland
          vulkan-loader
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      vulkan-tools
      mesa-demos
    ];
  };
}
