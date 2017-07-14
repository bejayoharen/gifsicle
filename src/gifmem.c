/* gifmem.c - Contains functions to open buffers for reading and writing.

   The LCDF GIF library is free software. It is distributed under the GNU
   General Public License, version 2; you can copy, distribute, or alter it at
   will, as long as this notice is kept intact and this source code is made
   available. There is no warranty, express or implied. */

#if HAVE_CONFIG_H
# include <config.h>
#endif
#include <lcdfgif/gif.h>
#include "fmemopen.h"
#include "memstream.h"
#include <assert.h>
#include <string.h>
#ifdef __cplusplus
extern "C" {
#endif
  
Gif_Buffer *Gif_NewUnalocatedBuffer( size_t size ) {
    Gif_Buffer *ret = Gif_New( Gif_Buffer );
    if( ret == NULL ) {
        return NULL;
    }
    ret->size = size;
    ret->buffer = NULL;

    return ret;
}
    
Gif_Buffer *Gif_NewBuffer( size_t size ) {
    Gif_Buffer *ret = Gif_New( Gif_Buffer );
    if( ret == NULL ) {
        return NULL;
    }
    ret->size = size;
    ret->buffer = Gif_Realloc(0, size, 1, __FILE__, __LINE__);
    if( ret->buffer == NULL ) {
        Gif_Delete( ret );
        return NULL;
    }
    return ret;
}

void Gif_DeleteBuffer( Gif_Buffer *b ) {
    Gif_Delete( b->buffer );
    Gif_Delete( b );
}

Gif_Stream *Gif_ReadBuffer( Gif_Buffer *buffer ) {
    FILE *r = fmemopen( buffer->buffer, buffer->size, "rb" );
    if( r == NULL ) {
        perror( "could not open buffer" );
        return NULL;
    }
    
    // -- read the file pointer and close it.
    Gif_Stream *instream = Gif_ReadFile(r); //FIXME: in production code, return val should checked for NULL
    
    fclose( r );
    
    return instream;
}

Gif_Buffer *Gif_WriteBuffer(Gif_Stream *instream) {
    Gif_Buffer *b = Gif_NewUnalocatedBuffer(0);
    FILE *w = open_memstream(&b->buffer, &b->size);
    
    int a = Gif_WriteFile(instream,w);
    
    if( a != 1 ) {
        Gif_DeleteBuffer(b);
        return NULL;
    }
    
    if( fclose(w) == EOF ) {
        return NULL;
    }
    
    return b;
}

#ifdef __cplusplus
}
#endif
