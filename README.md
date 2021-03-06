About this Fork
===============

You probably want the main branch of gifsicle. This is my attempt to create a dynamic library. This fork contains some changes to:

- Export some functions.
- Add some functions to allow opening and saving gifs to buffers rather than files.
- swig files.
- Log activity to help debugging and figure out what commandline options in gifsicle correspond to what function calls and arguments.
- A script to build the library. This is a dirty hack. Ideally I would have modified the makefile, but this was easier.
- A folder with some sample code. You will have to install the library on your system (or ~/lib on many systems) before this works.

Howto
=====

To do a clean compile from scratch, run:

`$ ./compile-dylib.sh TRACE`

where `TRACE` is either `true` or `false`. You'll want `false` in production.

Now, copy the include folder and `src/libgifsicle.dylib` into your project in the usual way.

In the `giflib-tester` folder you'll find some sample code for using gifsicle to copy, optmize and resize a gif. This is more useful than trying to read the gifsicle source files.

COPYRIGHT:
=========

In addition to crediting Eddie Kohler, who created Gifsicle, this branch uses a small file that
also require attribution. Attribubution in a compiled app will probably look something like this:


Copyright (C) 1997-2014 Eddie Kohler, ekohler@gmail.com
LCDF GIF library.

The GIF library is free software. It is distributed under the GNU General
Public License, version 2; you can copy, distribute, or alter it at will,
as long as this notice is kept intact and this source code is made
available. There is no warranty, express or implied.


Copyright 2011-2014 NimbusKit
fmemopen

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.


**Original Gifsicle Docs:**
======

Gifsicle
========

Gifsicle manipulates GIF image files. Depending on command line
options, it can merge several GIFs into a GIF animation; explode an
animation into its component frames; change individual frames in an
animation; turn interlacing on and off; add transparency; add delays,
disposals, and looping to animations; add and remove comments; flip
and rotate; optimize animations for space; change images' colormaps;
and other things.

Gifview, a companion program, displays GIF images and animations on an
X display. It can display multi-frame GIFs either as slideshows,
displaying one frame at a time, or as real-time animations.

Gifdiff, another companion program, checks two GIF files for identical
visual appearance. This is probably most useful for testing
GIF-manipulating software.

Each of these programs has a manpage, `PROGRAMNAME.1`.

The Gifsicle package comes with NO WARRANTY, express or implied,
including, but not limited to, the implied warranties of
merchantability and fitness for a particular purpose.

See `NEWS` in this directory for changes in recent versions. The Gifsicle home
page is:

http://www.lcdf.org/gifsicle/


Building Gifsicle on UNIX
-------------------------

Type `./configure`, then `make`.

If `./configure` does not exist (you downloaded from Github), run
`autoreconf -i` first.

`./configure` accepts the usual options; see `INSTALL` for details.
To build without gifview (for example, if you don't have X11), use
`./configure --disable-gifview`. To build without gifdiff,
use `./configure --disable-gifdiff`.

`make install` will build and install Gifsicle and its manual page
(under /usr/local by default).


Building Gifsicle on Windows
----------------------------

To build Gifsicle on Windows using Visual C, change into the `src`
directory and run

    nmake -f Makefile.w32

Gifview will not be built. The makefile is from Emil Mikulic
<darkmoon@connexus.net.au> with updates by Eddie Kohler and Steven
Marthouse <comments@vrml3d.com>.

To build Gifsicle on Windows using Borland C++, change into the `src`
directory and run

    nmake -f Makefile.bcc

Stephen Schnipsel <schnipsel@m4f.net> provided `Makefile.bcc`. You
will need to edit one of these Makefiles to use a different compiler.
You can edit it with any text editor (like Notepad). See the file for
more information.


Contact
-------

Please write me if you have trouble building or running Gifsicle, or
if you have suggestions or patches.

Eddie Kohler, ekohler@gmail.com
http://www.read.seas.harvard.edu/~kohler/


The GIF Patents and UnGIFs
--------------------------

Patents formerly restricted use of the Lempel-Ziv-Welch compression
algorithm used in GIFs. As of October 1, 2006, it is believed (by the
Software Freedom Law Center and the Free Software Foundation, among
others) that there are no significant patent claims interfering with
employment of the GIF format. For that reason, Gifsicle is completely
free software.

Nonetheless, Gifsicle can be configured to write run-length-encoded
GIFs, rather than LZW-compressed GIFs, avoiding these obsolete
patents. This idea was first implemented independently by Toshio
Kuratomi <badger@prtr-13.ucsc.edu> and Hutchison Avenue Software
Corporation (http://www.hasc.com/, <info@hasc.com>). Turn this on by
giving `./configure` the `--enable-ungif` switch. Now that the patents
have expired there is no good reason to turn on this switch, which can
make GIFs a factor of 2 larger or more. If your copy of Gifsicle says
`(ungif)` when you run `gifsicle --version`, it is writing
run-length-encoded GIFs.


Copyright/License
-----------------

All source code is Copyright (C) 1997-2014 Eddie Kohler.

IF YOU PLAN TO USE GIFSICLE ONLY TO CREATE OR MODIFY GIF IMAGES, DON'T
WORRY ABOUT THE REST OF THIS SECTION. Anyone can use Gifsicle however
they wish; the license applies only to those who plan to copy,
distribute, or alter its code. If you use Gifsicle for an
organizational or commercial Web site, I would appreciate a link to
the Gifsicle home page on any 'About This Server' page, but it's not
required.

This code is distributed under the GNU General Public License, Version
2 (and only Version 2). The GNU General Public License is available
via the Web at <http://www.gnu.org/licenses/gpl.html> or in the
'COPYING' file in this directory.

The following alternative license may be used at your discretion.

Permission is granted to copy, distribute, or alter Gifsicle, whole or
in part, as long as source code copyright notices are kept intact,
with the following restriction: Developers or distributors who plan to
use Gifsicle code, whole or in part, in a product whose source code
will not be made available to the end user -- more precisely, in a
context which would violate the GPL -- MUST contact the author and
obtain permission before doing so.


Authors
-------

Eddie Kohler <ekohler@gmail.com>
http://www.read.seas.harvard.edu/~kohler/
He wrote it.

Anne Dudfield <anne@mazunetworks.com>
http://www.frii.com/~annied/
She named it.

David Hedbor <david@hedbor.org>
Many bug reports and constructive whining about the optimizer.

Emil Mikulic <darkmoon@connexus.net.au>
Win32 port help.

Hans Dinsen-Hansen <dino@danbbs.dk>
http://www.danbbs.dk/~dino/
Adaptive tree method for GIF writing.
