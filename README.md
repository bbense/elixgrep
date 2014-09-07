Elixgrep
========

![alt text](https://api.travis-ci.org/bbense/elixgrep.png "Travis CI build status")

A project to learn elixir by building a grep that will cause the fan on my laptop to
turn on when it runs. 

Currently supports a simple string search in a list of files and directories. It will
expand to search all regular files in the subtree of any directory you give it. 

Usage
=======
```
   Usage:
        exilgrep [string] [file]
 
      Options:
        -h, [--help]                # Show this help message and quit.
        -c, [--chunksize] linecount # Number of lines to search per process.
 
      Description:
        Prints all the lines in file containing string
```

Build
=====

Run `mix escript.build` to create the elixgrep executable. 

To Do
=====

Currently running into file descriptor limits for large code trees.  