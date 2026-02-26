{
  pkgs,
  lib,
  username,
  host,
  ...
}:

let
  inherit (import ./variables.nix) gitUsername gitEmail;
in
{
  home.username = username;
  home.homeDirectory = lib.mkForce "/home/${username}";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.local/share"
    "$HOME/.nix-profile/bin"
    "/run/current-system/sw/bin"
  ];

  home.sessionVariables = {
    TERMINAL = "kitty";
  };

  home.packages = [
    pkgs.zsh-completions
  ];

  xdg.configFile."nvim".source = ./nvim;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  programs.gh.enable = true;

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = gitUsername;
        email = gitEmail;
      };
    };
  };

  programs.btop = {
    enable = true;
    settings.vim_keys = false;
  };

  programs.starship = {
    enable = true;
    package = pkgs.starship;
    enableNushellIntegration = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    package = pkgs.kitty;
    extraConfig = ''
      tab_bar_edge top
      shell /run/current-system/sw/bin/nu
      font_family JetBrainsMono Nerd Font
      font_size 12
      paste_actions filter
      confirm_os_window_close 0
    '';
    themeFile = "Kanagawa";
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;
  };

  programs.nushell = {
    enable = true;
    plugins = [
      pkgs.nushellPlugins.formats
      pkgs.nushellPlugins.query
      pkgs.nushellPlugins.polars
      pkgs.nushellPlugins.highlight
      pkgs.nushellPlugins.gstat
      pkgs.nushellPlugins.bson
    ];

    settings = {
      show_banner = false;
    };

    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/NixLinux#${host}";
      edit = "nvim ~/NixLinux/";
      sv = "sudo nvim";
      fr = "nh os switch --hostname ${host} /home/${username}/NixLinux";
      python = "python3";
      fu = "nh os switch --hostname ${host} --update /home/${username}/NixLinux";
      ncg = "nix-collect-garbage --delete-old and sudo nix-collect-garbage -d and sudo /run/current-system/bin/switch-to-configuration boot";
      v = "nvim";
      vim = "nvim";
      vi = "nvim";
      k = "kubectl";
      lg = "lazygit";
      cat = "bat";
      cd = "z";
      weather = "curl wttr.in";
      py = "python3";
      ".." = "cd ..";
    };

    extraConfig = ''
      $env.EDITOR = "nvim"
      $env.KUBECONFIG = $"($env.HOME)/.kube/config"
      $env.BUN_INSTALL = $"($env.HOME)/.bun"
      $env.SSH_AUTH_SOCK = $"($env.HOME)/.1password/agent.sock"

      $env.PATH = (
        $env.PATH
        | split row (char esep)
        | prepend [
            $"($env.HOME)/.cargo/bin"
            $"($env.BUN_INSTALL)/bin"
            $"($env.HOME)/.local/bin"
            "/run/current-system/sw/bin"
            $"($env.HOME)/bin"
          ]
      )
    '';
  };

  programs.direnv.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };

    shellAliases = {
      update = "sudo nixos-rebuild switch --flake ~/NixLinux#${host}";
      edit = "nvim ~/NixLinux/";
      sv = "sudo nvim";
      fr = "nh os switch --hostname ${host} /home/${username}/NixLinux";
      python = "python3";
      fu = "nh os switch --hostname ${host} --update /home/${username}/NixLinux";
      ncg = "nix-collect-garbage --delete-old && sudo nix-collect-garbage -d && sudo /run/current-system/bin/switch-to-configuration boot";
      v = "nvim";
      vim = "nvim";
      vi = "nvim";
      lg = "lazygit";
      cat = "bat";
      cd = "z";
      weather = "curl wttr.in";
      ls = "eza --icons";
      ll = "eza -lh --icons --grid --group-directories-first";
      la = "eza -lah --icons --grid --group-directories-first";
      py = "python3";
      ".." = "cd ..";
    };

    initContent = lib.mkOrder 550 ''
      fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)

      export EDITOR=nvim
      export KUBECONFIG="$HOME/.kube/config"
      export BUN_INSTALL="$HOME/.bun"
      export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"

      export PATH="$HOME/.cargo/bin:$BUN_INSTALL/bin:/run/current-system/sw/bin/:$HOME/bin:$PATH"
    '';
  };
}
