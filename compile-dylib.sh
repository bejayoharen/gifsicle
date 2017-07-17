#!/bin/bash -v
set -e


if [ "$1" == "true" ] ; then
	echo "debugging..."
	CFLAGS="-fvisibility=hidden -DTRACE_LOGGING -DGIFSICLE_DLL"
elif [ "$1" == "false" ] ; then
	echo "Not debugging..."
	CFLAGS="-fvisibility=hidden -DGIFSICLE_DLL"
else
	echo
	echo "Usage: $0 true|false"
	echo "    first argument signifies if extra trace debugging should be used."
	echo
	exit 1
fi

autoreconf -i
./configure
make clean
make CFLAGS="$CFLAGS" gifsicle
cd src
gcc -W -Wall -fvisibility=hidden -dynamiclib -install_name libgifsicle.dylib -o libgifsicle.dylib clp.o fmalloc.o giffunc.o gifread.o gifunopt.o merge.o optimize.o quantize.o support.o xform.o gifsicle.o  gifwrite.o gifmem.o fmemopen.o memstream.o
cd ..
nm -gU src/libgifsicle.dylib
otool -D src/libgifsicle.dylib

rm -r swig/gifsicle
swig -java -outdir swig/gifsicle gifsicle.i
