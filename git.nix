{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    
    settings = {
      user = {
        name = "ll";
        email = "lindermayr@b1-systems.de";  # Standard: Arbeitsmail (überall)
      };
      
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = false;
      push.autoSetupRemote = true;
      
      # Conditional includes für private GitHub Projekte
      includeIf."gitdir:~/Documents/arbeit/".path = "~/.gitconfig-github";
      
      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };
  };
  
  # Separate GitHub Konfiguration für private Projekte
  home.file.".gitconfig-github".text = ''
    [user]
      email = lindermayr@pm.me
  '';
}
