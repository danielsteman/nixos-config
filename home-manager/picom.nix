{ config, lib, pkgs, ... }:

{
  services.picom = {
    enable = true;
    activeOpacity = 0.8;
  };
}
