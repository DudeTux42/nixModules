{ pkgs, ... }:

let
  dotnvim = builtins.fetchGit {
    url = "https://github.com/DudeTux42/dotnvim";
    rev = "ccc3934ec2e8a34f9d34d985e095ff17849c527e";
  };
in
{
  programs.neovim = {
    enable = true;
    withRuby = false;
    withPython3 = false;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      lua-language-server
      nil
      typescript-language-server
      python3Packages.python-lsp-server
      ripgrep
      fd
      gcc
      texliveFull
      tectonic
      mermaid-cli
      sqlite
      ghostscript
      imagemagick
      luarocks

      # weitere Tools, die du in nvim brauchst
    ];
  };

  xdg.configFile."nvim" = {
    recursive = true;
    source = dotnvim;
  };
}
