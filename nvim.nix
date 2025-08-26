{ pkgs, ... }:

let
  dotnvim = builtins.fetchGit {
    url = "https://github.com/DudeTux42/dotnvim";
    rev = "a1352a10fc26aaf888307899ccdceced0f8d2816";
  };
in
{
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      lua-language-server
      nil
      nodePackages.typescript-language-server
      python3Packages.python-lsp-server
      ripgrep
      fd
      gcc
      texliveFull
      tectonic
      nodePackages.mermaid-cli
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
