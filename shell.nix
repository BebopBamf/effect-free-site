{ pkgs ? import (fetchTarball "https://nixos.org/channels/nixos-21.05/nixexprs.tar.xz") {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.zola
  ];

  shellHook = ''
    echo "Starting Zola Dev Shell"
  '';
}
