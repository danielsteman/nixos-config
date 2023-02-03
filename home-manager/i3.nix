{ config, lib, pkgs, ... }:

{
  xsession.scriptPath = ".hm-session";
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      modifier = "Mod4";

      gaps = {
        inner = 10;
        outer = 2;
      };

      startup = [
        {
          command = "exec i3-msg workspace 1";
          always = true;
          notification = false;
        }
      ];
    };
  };
}
