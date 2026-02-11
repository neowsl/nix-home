{ pkgs, pkgs-unstable }:

with pkgs;
[
  air
  astro-language-server
  bash-language-server
  black
  pkgs-unstable.bun
  clang-tools
  cling
  # dune_3
  elixir
  emmet-language-server
  erlang
  eslint_d
  flutter
  gcc14
  gdb
  gdtoolkit_4
  # pkgs-unstable.gleam
  go
  google-java-format
  gopls
  haskell.compiler.ghc9103
  haskellPackages.cabal-gild
  haskellPackages.cabal-install
  haskellPackages.ghcid
  haskellPackages.haskell-language-server
  haskellPackages.hlint
  haskellPackages.ormolu
  isort
  jdk25
  jdt-language-server
  lexical
  lua
  lua-language-server
  nil
  nixfmt-rfc-style
  nodejs
  nodePackages.prettier
  # ocaml
  # ocamlPackages.ocaml-lsp
  # ocamlPackages.ocamlformat
  # ocamlPackages.utop
  # opam
  # pkgs-unstable.oxlint
  prettierd
  pkgs-unstable.pyrefly
  python3
  python312Packages.pip
  rustup
  stylua
  stylish-haskell
  svelte-language-server
  tailwindcss-language-server
  tinymist
  typescript-language-server
  typst
  typstyle
  vscode-langservers-extracted
  yaml-language-server
]
