#!/bin/env bash

if [ "$1" == "-h" -o "$1" == "--help" -o "$1" == "help" ]; then
  echo "bash build.sh [ -h | --help | help | test | dist | install | uninstall ]"
  exit
fi

FILES="culang culang.lexer culang.parser culang.compiler culang.util"

# Este comando remplaza todas las palabras por culang.palabra
# echo $X | sed -E 's/\w+/culang.&/g'

if [ "$1" == "bootstrap" ]; then
  bash build.sh
  cd dist
  cp $FILES ..
  cd ..
  bash build.sh
  rm -f $FILES
  exit
fi

if [ "$1" == "uninstall" ]; then
  for a in $FILES; do
    cobre --remove $a
  done
  exit
fi

if [ "$1" != "install-only" ]; then
  compile () { echo compiling $1; cobre culang $1.cu dist/culang.$1; }
  compile util &&
  compile lexer &&
  compile parser &&
  compile compiler &&
  echo compiling culang &&
  cobre culang culang.cu dist/culang ||
  echo "Could not compile files"
fi

if [ "$1" == "install" -o "$1" == "install-only" ]; then
  cd dist
  for a in $FILES; do
    cobre --install $a
  done
  exit
fi
