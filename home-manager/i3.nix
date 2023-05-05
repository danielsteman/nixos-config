{ lib, pkgs, ... }:

{
  xsession.scriptPath = ".hm-session";
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      modifier = "Mod4";

      window.border = 0; 

      gaps = {
        inner = 10;
        outer = 5;
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
