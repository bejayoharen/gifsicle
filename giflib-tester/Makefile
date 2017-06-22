CFLAGS=-Igifsicle/include
LINKFLAGS=-L/Users/bjorn/lib -lgifsicle

all: giflib-tester

giflib-tester: main.o memstream.o fmemopen.o
	cc $(LINKFLAGS) $(CFLAGS) -o giflib-tester main.o memstream.o fmemopen.o

main.o: main.c
	cc $(CFLAGS) -c main.c -o main.o
memstream.o: memstream.c memstream.h
	cc $(CFLAGS) -c memstream.c -o memstream.o
fmemopen.o: fmemopen.c fmemopen.h
	cc $(CFLAGS) -c fmemopen.c -o fmemopen.o

clean:
	rm giflib-tester *.o
