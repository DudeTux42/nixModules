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
      nrs = "sudo nixos-rebuild switch";
      nrt = "sudo nixos-rebuild test";
      hms = "home-manager switch --flake ~/nix#ll";
      nfu = "nix flake update";
      
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
    
    initContent = ''
      # Custom prompt
      autoload -Uz vcs_info
      precmd() { vcs_info }
      
      zstyle ':vcs_info:git:*' formats '%b '
      
      setopt PROMPT_SUBST
      PROMPT='%F{cyan}%n@%m%f:%F{blue}%~%f %F{yellow}''${vcs_info_msg_0_}%f%# '
    '';
  };
}
