{ config, pkgs, username ? "musa", homeDir ? "/home/musa", ... }:

{
  home.username = username;
  home.homeDirectory = homeDir;

  programs.bashrc.enable = true;
  programs.git.enable = true;

  home.packages = with pkgs; [
    mv
    cp
    neovim
  ];

  # example dotfile
  home.file.".zshrc".text = ''
    export PATH=${pkgs.nodejs}/bin:$PATH
    # source system zsh if desired:
    # source /run/current-system/sw/share/zsh/site-functions
  '';
}

