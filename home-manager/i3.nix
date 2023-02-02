{ config, lib, pkgs, ... }:

{
  xsession.scriptPath = ".hm-session";
  xsession.windowManager.i3 = {
    enable = true;

    config = {
      modifier = "Mod4";
    };
  };
}
