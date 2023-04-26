{ pkgs, ... }: 

{
  services.spotifyd = {
    enable = true;
    settings = {
      username = "116885657";
      backend = "pulseaudio";
      device = "pipewire";
      deviceName = "spotifyd";
      bitrate = 320;
    };
  };
}
