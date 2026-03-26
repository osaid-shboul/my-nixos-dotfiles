{ config, pkgs, ... }:

{
  # ============================================================================
  # 1. الاستيراد (Modules)
  # ============================================================================
  imports = [ 
    ./hardware-configuration.nix
    ./modules/timezone.nix
    ./modules/tools.nix
    ./modules/security
    ./modules/nvidia.nix
    ./modules/gaming.nix
    ./modules/development.nix
    ./modules/virtualisation.nix 
    ./modules/desktop/hyprland.nix
    ./modules/audio.nix
  ];

  # ============================================================================
  # 2. إعدادات الإقلاع والشبكة (Boot & Networking)
  # ============================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  
  hardware.enableAllFirmware = true;

  # ============================================================================
  # 3. الميزات المخصصة (Custom Features)
  # ============================================================================
  features.security.fail2ban.enable = true;
  features.security.apparmor.enable = true;
  features.security.ssh.enable = false;
  features.security.permissions.enable = true;

  features.nvidia.enable = false;
  features.gaming.enable = false;
  features.gaming.enableGamemode = false;
  features.desktop.hyprland.enable = true;

  features.development.enable = true;
  features.virtualisation.enable = true;
  features.tools.enable = true;
   
  programs.waybar.enable = true;
  # ============================================================================
  # 4. واجهة المستخدم واللغات (UI & Localization)
  # ============================================================================
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ar_JO.UTF-8";
    LC_IDENTIFICATION = "ar_JO.UTF-8";
    LC_MEASUREMENT = "ar_JO.UTF-8";
    LC_MONETARY = "ar_JO.UTF-8";
    LC_NAME = "ar_JO.UTF-8";
    LC_NUMERIC = "ar_JO.UTF-8";
    LC_PAPER = "ar_JO.UTF-8";
    LC_TELEPHONE = "ar_JO.UTF-8";
    LC_TIME = "ar_JO.UTF-8";
  };

  services.xserver.enable = true;
  #  services.displayManager.sddm.enable = true;
  #  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ============================================================================
  # 5. الخدمات والأجهزة (Services & Hardware)
  # ============================================================================
  services.printing.enable = true;
  
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  
  # تفعيل خزنة كلمات السر
  services.gnome.gnome-keyring.enable = true;

  # السماح لـ NetworkManager بحفظ الروابط في الخزنة
  security.pam.services.login.enableGnomeKeyring = true;

  # ============================================================================
  # 6. إعدادات المستخدم والشيل (User & Shell)
  # ============================================================================
  users.users.osaid = {
    isNormalUser = true;
    description = "osaid";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh; # تفعيل Zsh للمستخدم
    packages = with pkgs; [ kdePackages.kate ];
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "sudo" "docker" "command-not-found" ];
    };
    # تشغيل ثيم Powerlevel10k
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  # ============================================================================
  # 7. البرامج والخطوط (Packages & Fonts)
  # ============================================================================
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    fzf
    fastfetch        # أضفنا هذا البرنامج هنا
    zsh-powerlevel10k
    meslo-lgs-nf
    waybar
    networkmanagerapplet
    pavucontrol
    libnotify
    swww
    psmisc
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    meslo-lgs-nf
  ];

  # ============================================================================
  # 8. إعدادات الـ Shell والإضافات (Shell Init & Aliases)
  # ============================================================================
  
  # هذا السطر يجب أن يكون خارج أي أقواس مربعة []
  environment.interactiveShellInit = ''
    fastfetch
  '';

  environment.shellAliases = {
    open = "nautilus . > /dev/null 2>&1 & disown";
    update = "sudo nixos-rebuild switch";
    conf = "sudo nano /etc/nixos/configuration.nix";
  };

  # ============================================================================
  # 9. إصدار النظام
  # ============================================================================
  system.stateVersion = "25.11";
}
