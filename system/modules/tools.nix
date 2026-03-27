{ config, lib, pkgs, ... }:

{
  options.features.tools = {
    enable = lib.mkEnableOption "Basic System Tools";
  };

  config = lib.mkIf config.features.tools.enable {
    environment.systemPackages = with pkgs; [
      wget
      htop
      fastfetch
    ];
  };
}
