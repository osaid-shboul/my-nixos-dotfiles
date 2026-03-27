{ config, lib, pkgs, ... }:

{
  options.features.gaming = {
    enable = lib.mkEnableOption "gaming support with Steam";
    enableGamemode = lib.mkEnableOption "Feral GameMode";
    enableGamescope = lib.mkEnableOption "gamescope session";
  };

  config = lib.mkIf config.features.gaming.enable {
    
      programs.steam = {
      enable = true;
      gamescopeSession.enable = config.features.gaming.enableGamescope;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    programs.gamemode = lib.mkIf config.features.gaming.enableGamemode {
      enable = true;
      settings = {
        general = { renice = 10; inhibit_screensaver = 1; };
        gpu = { apply_gpu_optimisations = "accept-responsibility"; gpu_device = 0; nv_powermizer_mode = 1; };
      };
    };

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
      MANGOHUD_CONFIG = "fps,frametime,gpu_stats,gpu_temp,cpu_stats,cpu_temp,ram,vram";
    };

    environment.systemPackages = with pkgs; [
      protonup-ng
      lutris
      mangohud
      wine
      winetricks
    ];
  };
}
