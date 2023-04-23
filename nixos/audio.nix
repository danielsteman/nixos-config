{ inputs, outputs, lib, config, pkgs, ... }: {
  hardware.pulseaudio.enable = true;
  sound.enable = true;
}

