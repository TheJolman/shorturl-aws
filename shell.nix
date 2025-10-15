with import <nixpkgs> {};
mkShell {
  nativeBuildInputs = [
    terraform
    python313
  ];
}
