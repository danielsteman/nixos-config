{ config, pkgs, ... }:

let
  my-python-packages = p: with p; [
    pandas
    pyarrow
    requests
    scikit-learn
    virtualenv
    # other python packages
  ];
in {
  environment.systemPackages = [
    (pkgs.python3.withPackages my-python-packages)
  ];
}
