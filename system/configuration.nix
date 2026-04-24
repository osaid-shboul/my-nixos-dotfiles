{ config, pkgs, ... }:

{
  # ============================================================================
  # 1. الاستيراد (Modules) - تأكد من وجود المجلدات في نفس المسار
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
  
  # تفعيل كافة تعريفات الهاردوير (ضروري للبلوتوث والواي فاي)
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
      
  # تفعيل Waybar كبرنامج نظام
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
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ============================================================================
  # 5. الخدمات والأجهزة (Services & Hardware)
  # ============================================================================
  services.printing.enable = true;
  services.ollama.enable = true;
  # إعدادات الصوت (Pipewire)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # تفعيل البلوتوث مع دعم الميزات التجريبية (نسبة البطارية)
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  services.blueman.enable = true;
  
  # دعم أيقونات النظام في البار (Tray Support)
#  services.status-notifier-watcher.enable = true;

  # تفعيل خزنة كلمات السر (GNOME Keyring)
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  # ============================================================================
  # 6. إعدادات المستخدم والشيل (User & Shell)
  # ============================================================================
  users.users.osaid = {
    isNormalUser = true;
    description = "osaid";
    extraGroups = [ "networkmanager" "wheel" "docker" "video" "audio" ];
    shell = pkgs.zsh;
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
    promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  };

  # ============================================================================
  # 7. البرامج والخطوط (Packages & Fonts)
  # ============================================================================
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # أدوات النظام الأساسية
    git vim wget fzf psmisc libnotify
    
    # الواجهة والبار (تعديل لدعم البلوتوث)
    waybar
    networkmanagerapplet
    pavucontrol # للتحكم بالصوت
    blueman     # مدير البلوتوث
    swww        # للخلفيات
    brightnessctl # للتحكم بالسطوع
    ollama

    # البرامج اليومية
    google-chrome
    fastfetch
    zsh-powerlevel10k
    nodejs
    ripgrep
    
   # الوسائط المتعددة
   loupe          # عارض الصور المودرن
   mpv            # مشغل الفيديو الاحترافي
   amberol        # مشغل الصوتيات الأنيق

   # المكتب والأعمال
   onlyoffice-desktopeditors
  ];

  # إعدادات الخطوط (ضرورية للأيقونات في Waybar)
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.meslo-lg # النسخة الصحيحة للـ Nerd Font
    font-awesome        # أيقونات البلوتوث والشبكة 
 ];

  # ============================================================================
  # 8. إعدادات الـ Shell والإضافات (Shell Init & Aliases)
  # ============================================================================
  environment.interactiveShellInit = ''
    fastfetch
  '';

  environment.shellAliases = {
    open = "nautilus . > /dev/null 2>&1 & disown";
    update = "sudo nixos-rebuild switch";
    # تعديل الـ Aliases لتعمل من مجلدك المنظم
    conf = "sudo nano ~/nixos-config/system/configuration.nix";
    dot = "cd ~/nixos-config";
    hyprconf = "nano ~/nixos-config/dotfiles/hypr/hyprland.conf";
    ai ="OPENAI_BASE_URL=http://127.0.0.1:11434/v1 npx @gitlawb/openclaude --model qwen2.5-coder:3b";
    sync = "~/nixos-config/update.sh";
  };

  # ============================================================================
  # 9. إصدار النظام
  # ============================================================================
  system.stateVersion = "25.11";
}
