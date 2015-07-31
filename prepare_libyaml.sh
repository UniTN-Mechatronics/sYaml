#!/usr/bin/env bash

export LIBYAML="yaml-0.1.5"
export ROOT_DIR=$(pwd)

mkdir -p tmp
mkdir -p libyaml/include
mkdir -p libyaml/src

cd tmp
wget "http://pyyaml.org/download/libyaml/${LIBYAML}.tar.gz"
tar xzf ${LIBYAML}.tar.gz
rm *.tar.gz*
cd ${LIBYAML}
./configure

cd ${ROOT_DIR}
mv tmp/${LIBYAML}/include/*.h ./libyaml/include
mv tmp/${LIBYAML}/config.h ./libyaml/include
mv tmp/${LIBYAML}/src/*.c ./libyaml/src
mv tmp/${LIBYAML}/src/*.h ./libyaml/src