autoreconf -i
./configure
make CFLAGS="-fvisibility=hidden -DGIFSICLE_DLL" gifsicle
cd src
gcc -W -Wall -fvisibility=hidden -dynamiclib -o gifsicle.dylib clp.o fmalloc.o giffunc.o gifread.o gifunopt.o merge.o optimize.o quantize.o support.o xform.o gifsicle.o  gifwrite.o
cd ..
nm -gU src/gifsicle
