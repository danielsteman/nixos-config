{ config, lib, pkgs, ... }:

{
  services.picom = {
    enable = true;
    inactiveOpacity = 0.8;
  };
}
