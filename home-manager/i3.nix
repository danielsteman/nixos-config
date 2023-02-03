{ config, lib, pkgs, ... }:

{
  xsession.scriptPath = ".hm-session";
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      modifier = "Mod4";

      gaps = {
        inner = 15;
        outer = 5;
      };
    };
  };
}
