:requires#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "memstream.h"
#include "fmemopen.h"

#include <lcdfgif/gif.h>

void usage() {
	printf( "usage:\n\trunner input size output\n" );
}


int simpleCopy( char * input, char *output ) {
	// -- open input file
	FILE * infile = fopen( input, "r" );
	if( !infile ) {
		perror( "Could not open input file" );
		return 1;
	}

	Gif_Stream *instream = Gif_ReadFile(infile);

	if( fclose(infile) == EOF ) {
		perror( "could not close output." );
		return 1;
	}

	// -- open output file
	FILE * outfile = fopen( output, "w+" );
	if( !infile ) {
		perror( "Could not open output file" );
		return 1;
	}

	int a = Gif_WriteFile(instream,outfile);

	if( a != 1 ) {
		printf( "Could not write file" );
		return 1;
	}

	if( fclose(outfile) == EOF ) {
		perror( "could not close output." );
		return 1;
	}

	Gif_DeleteStream(instream);

	return 0;
}

int resizeCopy( char * input, char *output, int width ) {
	// -- open input file
	FILE * infile = fopen( input, "r" );
	if( !infile ) {
		perror( "Could not open input file" );
		return 1;
	}

	Gif_Stream *instream = Gif_ReadFile(infile);

	if( fclose(infile) == EOF ) {
		perror( "could not close output." );
		return 1;
	}

	// -- unoptimize
	Gif_Unoptimize(instream);

	// -- resize
	Gif_ResizeStream(instream, (double)(width), 0.0, 0, SCALE_METHOD_MIX, 0 );
	
	// -- re-optimize
	Gif_OptimizeFragments(instream, 2, 0);

	// -- open output file
	FILE * outfile = fopen( output, "w+" );
	if( !infile ) {
		perror( "Could not open output file" );
		return 1;
	}

	int a = Gif_WriteFile(instream,outfile);

	if( a != 1 ) {
		printf( "Could not write file" );
		return 1;
	}

	if( fclose(outfile) == EOF ) {
		perror( "could not close output." );
		return 1;
	}

	Gif_DeleteStream(instream);

	return 0;
}

int resizeBuffer( char * input, char *output, int width ) {
	// -- open input file and copy contents to a buffer.
	FILE * infile = fopen( input, "r" ); //binary mode may be necessary on some platforms
	if( !infile ) {
		perror( "Could not open input file" );
		return 1;
	}

	fseek(infile, 0, SEEK_END);
	long fsize = ftell(infile);
	fseek(infile, 0, SEEK_SET);  //same as rewind(f);

	char *inbuf = malloc(fsize);
	if( inbuf == NULL ) {
		perror( "malloc failed" );
		return 1;
	}
	if( 1 != fread(inbuf, fsize, 1, infile) ) {
		perror( "failed to read file" );
		return 1;
	}

	if( fclose(infile) == EOF ) {
		perror( "could not close input" );
		return 1;
	}

	// -- make a file pointer from the buffer. This requires POSIX
	FILE *r = fmemopen( inbuf, fsize, "r" );//binary mode may be necessary on some platforms
	if( r == NULL ) {
		perror( "could not open buffer" );
		return 1;
	}

	// -- read the file pointer and close it.
	Gif_Stream *instream = Gif_ReadFile(r); //FIXME: in production code, return val should checked for NULL

	fclose( r );



	// -- -- now we can work with the gif stream.
	// Let's resize:
	Gif_Unoptimize(instream);
	Gif_ResizeStream(instream, (double)(width), 0.0, 0, SCALE_METHOD_MIX, 0 );
	Gif_OptimizeFragments(instream, 2, 0);


	// -- -- now we are ready to save it!
	
	// -- make filestream that points to a buffer
	char *outbuf;
	size_t outbufsize;
	FILE *w = open_memstream(&outbuf, &outbufsize);

	int a = Gif_WriteFile(instream,w);

	if( a != 1 ) {
		printf( "Could not write buffer" );
		return 1;
	}

	if( fclose(w) == EOF ) {
		perror( "could not close output." );
		return 1;
	}

	// -- dispose of the stream.
	Gif_DeleteStream(instream);

	// at this point the data is in our buffer.
	// let's save it to a file, and delete the buffer.

	// -- open output file
	FILE * outfile = fopen( output, "w+" ); //binary mode may be necessary on some platforms
	if( !infile ) {
		perror( "Could not open output file" );
		return 1;
	}

	if( 1 != fwrite( outbuf, outbufsize, 1, outfile ) ) {
		perror( "Could not write to output file" );
		return 1;
	}

	
	if( fclose(outfile) == EOF ) {
		perror( "could not close output." );
		return 1;
	}

	free( outbuf );

	return 0;
}


int main( int argc, char * argv[] )
{
	if( argc != 4 ) {
		usage();
		return 1;
	}
	char * input = argv[1];
	int size = atoi(argv[2]);
	char * output = argv[3];

	if( size <= 0 ) {
		usage();
		return 1;
	}

	return resizeBuffer(input, output, size);
}
