{
  pkgs,
  lib,
  username,
  host,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    # ./modules/nvidia.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = host;
  networking.networkmanager.enable = true;

  time.timeZone = lib.mkDefault "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.wayland.enable = true;
  };

  services.openssh.enable = true;

  virtualisation.docker.enable = true;


  users.defaultUserShell = pkgs.nushell;

  users.users.${username} = {
    isNormalUser = true;
    shell = pkgs.nushell;
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
    ];
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    gcc
    gnumake
    unzip
    vim
    go
    openjdk17
    lazygit
    nushell
    tesseract
    nixd
    nixfmt
    ansible
    bat
    binwalk
    btop
    mongosh
    butane
    bun
    cmake
    direnv
    emacs
    eza

    kdePackages.discover # Optional: Software center for Flatpaks/firmware updates
    kdePackages.kcalc # Calculator
    kdePackages.kcharselect # Character map
    kdePackages.kclock # Clock app
    kdePackages.kcolorchooser # Color picker
    kdePackages.kolourpaint # Simple paint program
    kdePackages.ksystemlog # System log viewer
    kdePackages.sddm-kcm # SDDM configuration module
    kdiff3 # File/directory comparison tool

    # Hardware/System Utilities (Optional)
    kdePackages.isoimagewriter # Write hybrid ISOs to USB
    kdePackages.partitionmanager # Disk and partition management
    hardinfo2 # System benchmarks and hardware info
    wayland-utils # Wayland diagnostic tools
    wl-clipboard # Wayland copy/paste support
    vlc # Media player

    fastfetch
    fd
    fortune
    fzf
    gemini-cli
    gh
    glab
    gradle
    terraform
    helix
    htmlq
    hyfetch
    k9s
    lazygit
    libiodbc
    libpq
    mongosh
    mpv
    neovim
    nmap
    nushell
    octave
    opencode
    opentofu
    caligula
    pipx
    plantuml
    docker-compose
    postgresql
    qemu
    ruby
    starship
    tmux
    valkey
    wget
    whois
    yazi
    zellij
    zoxide
    nodejs

    _1password-cli

    audacity

    inkscape
    librecad

    dbeaver-bin
    mongodb-compass

    fira-code

    jellyfin-media-player

    vscode
    ripgrep
    statix

    qbittorrent

    texstudio
  ];
  
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  system.stateVersion = "25.11";
}
