{ pkgs, ... }: 

{
  services.spotifyd = {
    enable = true;
    settings = {
      global = {
        username = "116885657";
        password = (builtins.readFile ~/.password); 
      };
      backend = "pulseaudio";
      device = "pipewire";
      deviceName = "spotifyd";
      bitrate = 320;
    };
  };
}
