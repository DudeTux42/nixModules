{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    shellAliases = {
      ll = "ls -lah";
      la = "ls -A";
      l = "ls -CF";
      ".." = "cd ..";
      "..." = "cd ../..";
      
      # Nix shortcuts
      nrs = "sudo nixos-rebuild switch --flake /home/ll/nix#nixos";
      nrt = "sudo nixos-rebuild test --flake /home/ll/nix#nixos";
      hms = "home-manager switch --flake ~/nix#ll";
      nfu = "nix flake update";
      ncf = "sudo nvim /home/ll/nix/system/configuration.nix";
      
      # Git shortcuts
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";

    };
    
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    
    initContent = ''
      # Powerlevel10k config
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };

  # Declaratively manage p10k config
  home.file.".p10k.zsh" = {
    source = ./p10k.zsh;
    force = true;
  };
}
