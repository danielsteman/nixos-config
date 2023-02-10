{ config, pkgs, ... }: 

let
  my-python-packages = p: with p; [
    virtualenv
    pandas
    requests
    # other python packages
  ];
in {
  environment.systemPackages = [
    (pkgs.python3.withPackages my-python-packages)
  ];
}
