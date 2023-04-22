{ pkgs, ... }: 

{
  services.spotifyd = {
    enable = true;
  };
  programs.spotify-tui = {
    enable = true;
  };
}
