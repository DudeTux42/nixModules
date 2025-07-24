{ pkgs, ... }:

let
  dotnvim = builtins.fetchGit {
    url = "https://github.com/DudeTux42/dotnvim";
    rev = "978dff86407d08d5f9344fe8ca9e6887f6460e33";
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
      texlifeFull
      tectonic
      nodePackages.mermaid-cli
      sqlite
      ghostscript
      imagemagick

      # weitere Tools, die du in nvim brauchst
    ];
  };

  xdg.configFile."nvim" = {
    recursive = true;
    source = dotnvim;
  };
}
