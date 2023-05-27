{ inputs, outputs, lib, config, pkgs, callPackage, ... }:

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
        outer = -10;
      };

      startup = [
        {
          command = "exec i3-msg workspace 1";
          always = true;
          notification = false;
        }
      ];
      bars = [
        {
          position = "top";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
          fonts = {
            names = [ "DejaVu Sans Mono" "FontAwesome5Free" ];
            style = "Bold Semi-Condensed";
            size = 10.0;
          };
        }
      ];
    };
  };
}
