rxattr: A simple interface to filesystem extended attributes for Ruby
=====================================================================

This was a really quick and dirty wrapper to get xattr support for one
of my projects. Due to limited time, it's not in gem form, sorry. But
maybe it's useful for someone anyway.

Requirements
------------

Just the ffi gem.

Usage
-----

Every File object gains a few methods. xattr acts as an
array-like. You can query attributes via [] and set them via
[]=. Setting an attribute nil will remove it. A list of all keys is
available via listxattr and a hash of all xattrs, key and value, is
available via dumpxattr.

    f = File.new("testfile.txt")
    f.xattr["user.note"] = "Just a text file"
    f.xattr["user.note"]
      => "just a text file"
    f.listxattr
      => ["user.note"]
    f.dumpxattr
      => { "user.note" => "Just a text file"

Caveats
-------

It's far from being good code, but it works. I used it only for
strings, so everything gets converted to UTF_8 before and after
writing/reading.

It's only a thin wrapper. Depending on the system you normally have
only access to a specific namespace. For linux, that's the "user.*"
namespace. Forgetting the "user." part will raise an error.

License
-------

BSD 2-Clause.


Copyright (c) 2012, Sören Finster
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

- Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.

- Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
