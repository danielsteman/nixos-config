{ config, pkgs, ... }:

let
  my-python-packages = p: with p; [
    "dvc[all]"
    pandas
    "pre-commit"
    pyarrow
    pytest
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
