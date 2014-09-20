Elixgrep
========

![alt text](https://api.travis-ci.org/bbense/elixgrep.png "Travis CI build status")

A project to learn elixir by building a grep that will cause the fan on my laptop to
turn on when it runs. It has since expanded to a general purpose program for running
a function on many files and returning the results. 

Currently supports a simple string search in a list of files and directories. It will
expand to search all regular files in the subtree of any directory you give it. It
also has the ablity to load elixir code plugins to implement a general map/reduce 
(in the Hadoop sense). 



Usage
=======
```
   Usage:
        exilgrep [string] [files and/or directories]
 
      Options:
        -h, [--help]                # Show this help message and quit.
        -c, [--count] filecount     # Number of files to search in parallel.
                                    # Default is 512.
        -p, [--plugin] elixir_code  # Basename of a plugin to implement 
                                    # other functions. 
 
      Description:
        Prints all the lines in file containing string ( default) 

        Runs a version of map/reduce on the file list given on the command
        line. Requires an elixir module that implements two functions. 

        gr_map(options,path) -> {path,[]}
        gr_reduce(options) Expects to recieve two kinds of messages 
                    { item: { path, []}}
                    { finalize: } -> Should output results and exit.
```

Build
=====

Run `mix escript.build` to create the elixgrep executable. 

WARNING
========

This program can easily drive the load on your machine to the number of availiable cores
if you point it at a large enough set of files. If you do decide to use it on a production
server, use the count option to limit it's use of resources.

Plugins
========

There are currently two plugins available: 

grep
----
     elixgrep -p grep [PCRE regexp] [files/directories]

This plugin will list out all the files and lines that 
match the regex, it only examines files one line per time
so it won't match multiline regex.

find
----
     elixgrep -p find --mtime target_file [verb] [files/directories]

This plugin will search for files based on either their basename or 
File.stat output. Currently it only supports `--atime, --ctime, --mtime`

The verbs you can use with the stat options are:

-newer   Find files newer than the target file.
-older   Find files older than the target file.
-around  Find files that are within `--delta seconds` of the target file. The default delta is 24 hours. 

     elixgrep -p find [regex] [files/directories]

Without any attribute arguements, the plugin uses the given regex
to match against the basename of the files. 


To Do
=====

Expand plugins to implement a tripwire, access monitoring, etc.. 

Work on creating a plugin path discovery mechanism.

Figure out how plugins can implement plugin specific help.  