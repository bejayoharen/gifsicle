/* gifsicle.i SWIG input file */
%module gifsicle
%{
  #include "include/lcdfgif/gif.h"
%}


#ifndef LCDF_GIF_H /* -*- mode: c -*- */
#define LCDF_GIF_H
#include <stdio.h>
#include <stdlib.h>
#include <lcdf/inttypes.h>
#ifdef __cplusplus
extern "C" {
#endif

// Shared library support
#ifdef GIFSICLE_DLL
# if defined _WIN32 || defined __CYGWIN__
#  define GIFSICLE_HELPER_DLL_IMPORT __declspec(dllimport)
#  define GIFSICLE_HELPER_DLL_EXPORT __declspec(dllexport)
#  define GIFSICLE_HELPER_DLL_LOCAL
# else
#  if __GNUC__ >= 4
#   define GIFSICLE_HELPER_DLL_IMPORT __attribute__ ((visibility ("default")))
#   define GIFSICLE_HELPER_DLL_EXPORT __attribute__ ((visibility ("default")))
#   define GIFSICLE_HELPER_DLL_LOCAL  __attribute__ ((visibility ("hidden")))
#  else
#   define GIFSICLE_HELPER_DLL_IMPORT
#   define GIFSICLE_HELPER_DLL_EXPORT
#   define GIFSICLE_HELPER_DLL_LOCAL
#   warning "visibility not supported by this compiler"
#  endif
# endif
# define GIFSICLE_API GIFSICLE_HELPER_DLL_EXPORT
#else
# define GIFSICLE_API
#endif //GIFSICLE_DLL

    

typedef struct Gif_Stream       Gif_Stream;
typedef struct Gif_Image        Gif_Image;
typedef struct Gif_Colormap     Gif_Colormap;
typedef struct Gif_Comment      Gif_Comment;
typedef struct Gif_Extension    Gif_Extension;
typedef struct Gif_Record       Gif_Record;

typedef uint16_t Gif_Code;


/** GIF_STREAM **/

struct Gif_Stream {
    Gif_Image **images;
    int nimages;
    int imagescap;

    Gif_Colormap *global;
    uint16_t background;        /* 256 means no background */

    uint16_t screen_width;
    uint16_t screen_height;
    long loopcount;             /* -1 means no loop count */

    Gif_Comment* end_comment;
    Gif_Extension* end_extension_list;

    unsigned errors;

    int userflags;
    const char* landmark;
    int refcount;
};

GIFSICLE_API Gif_Stream *    Gif_NewStream(void);
GIFSICLE_API void            Gif_DeleteStream(Gif_Stream *);

GIFSICLE_API Gif_Stream *    Gif_CopyStreamSkeleton(Gif_Stream *);
GIFSICLE_API Gif_Stream *    Gif_CopyStreamImages(Gif_Stream *);

GIFSICLE_API void            Gif_CalculateScreenSize(Gif_Stream *, int force);
GIFSICLE_API int             Gif_Unoptimize(Gif_Stream *);
GIFSICLE_API int             Gif_FullUnoptimize(Gif_Stream *, int flags);

// optimize flags are (I think) the flags passed to the -O commandline argument.
// huge_Stream is generally set to true if the file is over 200MB
GIFSICLE_API void            Gif_OptimizeFragments(Gif_Stream *gfs, int optimize_flags, int huge_stream);


/** GIF_IMAGE **/

struct Gif_Image {
    uint16_t width;
    uint16_t height;

    uint8_t **img;              /* img[y][x] == image byte (x,y) */
    uint8_t *image_data;

    uint16_t left;
    uint16_t top;
    uint16_t delay;
    uint8_t disposal;
    uint8_t interlace;

    Gif_Colormap *local;
    short transparent;          /* -1 means no transparent index */

    uint16_t user_flags;

    char *identifier;
    Gif_Comment* comment;
    Gif_Extension* extension_list;

    void (*free_image_data)(void *);

    uint32_t compressed_len;
    uint8_t *compressed;
    void (*free_compressed)(void *);

    void *user_data;
    void (*free_user_data)(void *);
    int refcount;

};

GIFSICLE_API Gif_Image *     Gif_NewImage(void);
GIFSICLE_API void            Gif_DeleteImage(Gif_Image *gfi);

GIFSICLE_API int             Gif_AddImage(Gif_Stream *gfs, Gif_Image *gfi);
GIFSICLE_API void            Gif_RemoveImage(Gif_Stream *gfs, int i);
GIFSICLE_API Gif_Image *     Gif_CopyImage(Gif_Image *gfi);
GIFSICLE_API void            Gif_MakeImageEmpty(Gif_Image* gfi);

GIFSICLE_API Gif_Image *     Gif_GetImage(Gif_Stream *gfs, int i);
GIFSICLE_API Gif_Image *     Gif_GetNamedImage(Gif_Stream *gfs, const char *name);
GIFSICLE_API int             Gif_ImageNumber(Gif_Stream *gfs, Gif_Image *gfi);

typedef struct {
    int flags;
    void *padding[7];
} Gif_CompressInfo;

#define         Gif_UncompressImage(gfs, gfi) Gif_FullUncompressImage((gfs),(gfi),0)
GIFSICLE_API int             Gif_FullUncompressImage(Gif_Stream* gfs, Gif_Image* gfi,
                                        Gif_ReadErrorHandler handler);
GIFSICLE_API int             Gif_CompressImage(Gif_Stream *gfs, Gif_Image *gfi);
GIFSICLE_API int             Gif_FullCompressImage(Gif_Stream *gfs, Gif_Image *gfi,
                                      const Gif_CompressInfo *gcinfo);
GIFSICLE_API void            Gif_ReleaseUncompressedImage(Gif_Image *gfi);
GIFSICLE_API void            Gif_ReleaseCompressedImage(Gif_Image *gfi);
GIFSICLE_API int             Gif_SetUncompressedImage(Gif_Image *gfi, uint8_t *data,
                        void (*free_data)(void *), int data_interlaced);
GIFSICLE_API int             Gif_CreateUncompressedImage(Gif_Image* gfi, int data_interlaced);

GIFSICLE_API int             Gif_ClipImage(Gif_Image *gfi, int l, int t, int w, int h);

GIFSICLE_API void            Gif_InitCompressInfo(Gif_CompressInfo *gcinfo);



/** GIF_COMMENT **/
/*
struct Gif_Comment {
    char **str;
    int *len;
    int count;
    int cap;
};

GIFSICLE_API Gif_Comment *   Gif_NewComment(void);
GIFSICLE_API void            Gif_DeleteComment(Gif_Comment *);
GIFSICLE_API int             Gif_AddCommentTake(Gif_Comment *, char *, int);
GIFSICLE_API int             Gif_AddComment(Gif_Comment *, const char *, int);
*/

/** GIF_EXTENSION **/

/*
struct Gif_Extension {
    int kind;
    char* appname;
    int applength;
    uint8_t* data;
    uint32_t length;
    int packetized;

    Gif_Stream *stream;
    Gif_Image *image;
    Gif_Extension *next;
    void (*free_data)(void *);
};


GIFSICLE_API Gif_Extension*  Gif_NewExtension(int kind, const char* appname, int applength);
GIFSICLE_API void            Gif_DeleteExtension(Gif_Extension* gfex);
GIFSICLE_API Gif_Extension*  Gif_CopyExtension(Gif_Extension* gfex);
GIFSICLE_API int             Gif_AddExtension(Gif_Stream* gfs, Gif_Image* gfi,
                                 Gif_Extension* gfex);
*/


/** READING AND WRITING **/

struct Gif_Record {
    const unsigned char *data;
    uint32_t length;
};

#define GIF_READ_COMPRESSED             1
#define GIF_READ_UNCOMPRESSED           2
#define GIF_READ_CONST_RECORD           4
#define GIF_READ_TRAILING_GARBAGE_OK    8
#define GIF_WRITE_CAREFUL_MIN_CODE_SIZE 1
#define GIF_WRITE_EAGER_CLEAR           2
#define GIF_WRITE_OPTIMIZE              4
#define GIF_WRITE_SHRINK                8

    GIFSICLE_API void            Gif_SetErrorHandler(Gif_ReadErrorHandler handler);
GIFSICLE_API Gif_Stream*     Gif_ReadFile(FILE* f);
GIFSICLE_API Gif_Stream*     Gif_FullReadFile(FILE* f, int flags, const char* landmark,
                                 Gif_ReadErrorHandler handler);
GIFSICLE_API Gif_Stream*     Gif_ReadRecord(const Gif_Record* record);
GIFSICLE_API Gif_Stream*     Gif_FullReadRecord(const Gif_Record* record, int flags,
                                   const char* landmark,
                                   Gif_ReadErrorHandler handler);
GIFSICLE_API int             Gif_WriteFile(Gif_Stream *gfs, FILE *f);
GIFSICLE_API int             Gif_FullWriteFile(Gif_Stream *gfs,
                                  const Gif_CompressInfo *gcinfo, FILE *f);

#define Gif_ReadFile(f)         Gif_FullReadFile((f),GIF_READ_UNCOMPRESSED,0,0)
#define Gif_ReadRecord(r)       Gif_FullReadRecord((r),GIF_READ_UNCOMPRESSED,0,0)
#define Gif_CompressImage(s, i) Gif_FullCompressImage((s),(i),0)
#define Gif_WriteFile(s, f)     Gif_FullWriteFile((s),0,(f))

typedef struct Gif_Writer Gif_Writer;
GIFSICLE_API Gif_Writer*     Gif_IncrementalWriteFileInit(Gif_Stream* gfs, const Gif_CompressInfo* gcinfo, FILE *f);
GIFSICLE_API int             Gif_IncrementalWriteImage(Gif_Writer* grr, Gif_Stream* gfs, Gif_Image* gfi);
GIFSICLE_API int             Gif_IncrementalWriteComplete(Gif_Writer* grr, Gif_Stream* gfs);

/** Resizing **/
// this will resize a gif stream to the given width and height.
// resize flags (can be ored together?)
#define GT_RESIZE_FIT           1
#define GT_RESIZE_FIT_DOWN      2
#define GT_RESIZE_FIT_UP        4
#define GT_RESIZE_MIN_DIMEN     8

// resize methods
#define SCALE_METHOD_POINT      0
#define SCALE_METHOD_BOX        1
#define SCALE_METHOD_MIX        2
#define SCALE_METHOD_CATROM     3
#define SCALE_METHOD_LANCZOS2   4
#define SCALE_METHOD_LANCZOS3   5
#define SCALE_METHOD_MITCHELL   6

GIFSICLE_API void            Gif_ResizeStream(Gif_Stream* gfs, double new_width, double new_height, int flags, int method, int scale_colors);


/** Buffer I/O **/
struct Gif_Buffer {
    char *buffer;
    size_t size;
};
typedef struct Gif_Buffer Gif_Buffer;
    
GIFSICLE_API Gif_Buffer *Gif_NewBuffer( size_t size );

GIFSICLE_API void Gif_DeleteBuffer( Gif_Buffer *b );

GIFSICLE_API Gif_Stream *Gif_ReadBuffer( Gif_Buffer *buffer );

GIFSICLE_API Gif_Buffer *Gif_WriteBuffer( Gif_Stream *instream );


#ifdef __cplusplus
}
#endif
#endif
