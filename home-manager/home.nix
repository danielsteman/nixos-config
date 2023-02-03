# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    ./i3.nix
    ./picom.nix
    # If you want to use modules your own flake exports (from modules/home-manager):
    # outputs.homeManagerModules.example

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.modifications
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  # TODO: Set your username
  home = {
    username = "daniel";
    homeDirectory = "/home/daniel";
    sessionVariables = {
      EDITOR="nvim";
      BROWSER="firefox";
      TERMINAL="kitty";
    };
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  # home.packages = with pkgs; [ steam ];

  # Enable xsession
  xsession.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName  = "Daniel Steman";
    userEmail = "daniel-steman@live.nl";

    extraConfig = {
      commit.gpgsign = true;
      gpg.format = "ssh";
      user.signingkey = "/home/daniel/.ssh/id_ed25519.pub";
    };
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;

    initExtraBeforeCompInit = ''
      # p10k instant prompt
      P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
    '';
    plugins = with pkgs; [
      {
        file = "powerlevel10k.zsh-theme";
        name = "powerlevel10k";
        src = "${zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
      {
        file = ".p10k.zsh";
        name = "powerlevel10k-config";
        src = /home/daniel;
      }
    ];
    shellAliases = {
      # some more ls aliases
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      lt = "ls --human-readable --size -1 -S --classify";
      c = "clear";

      # virtual env
      cv = "virtualenv venv";
      av = ". venv/bin/activate";
      dv = "deactivate";
      v = "cv; av";

      # pip

      pi="pip install -r requirements.txt&&pip install -r requirements-dev.txt";

      # git
      gca = "git add .&&git commit -m";
      gpl = "git pull";
      gph = "git push";
      gcp = "git checkout production";
      gc = "git checkout";
      gsh = "git stash";
      gshp = "git stash pop";
      gmp = "git merge production";
      gmd = "git merge development";
      grmc = "gcp&&gpl&&gc -&&gmp&&gph";
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.neovim = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.9";
    };
  };

  programs.firefox = {
    enable = true;
  };

  programs.i3status-rust.enable = true; 

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
