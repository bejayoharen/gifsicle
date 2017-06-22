#!/bin/bash
set -e

autoreconf -i
./configure
make clean
make CFLAGS="-fvisibility=hidden -DTRACE_LOGGING -DGIFSICLE_DLL" gifsicle
cd src
gcc -W -Wall -fvisibility=hidden -dynamiclib -install_name libgifsicle.dylib -o libgifsicle.dylib clp.o fmalloc.o giffunc.o gifread.o gifunopt.o merge.o optimize.o quantize.o support.o xform.o gifsicle.o  gifwrite.o
cd ..
nm -gU src/libgifsicle.dylib
otool -D src/libgifsicle.dylib
