{ pkgs, ... }:

let
  allNerdFonts = builtins.filter pkgs.lib.attrsets.isDerivation
    (builtins.attrValues pkgs.nerd-fonts);
in
{
  home.packages = allNerdFonts;
}
