Elixgrep
========

![alt text](https://api.travis-ci.org/bbense/elixgrep.png "Travis CI build status")

A project to learn elixir by building a grep that will cause the fan on my laptop to
turn on when it runs. It has since expanded to a general purpose program for running
a function on many files and returning the results. 

Currently supports a simple string search in a list of files and directories. It will
expand to search all regular files in the subtree of any directory you give it. It
also has the ablity to load elixir code plugins to implement a general map/reduce. 

A simple grep plugin that simply dupilicates the default functionality is included. 
More plugins will be made available as time permits. 


Usage
=======
```
   Usage:
        exilgrep [string] [files and/or directories]
 
      Options:
        -h, [--help]                # Show this help message and quit.
        -c, [--count] filecount     # Number of files to search in parallel.
        -p, [--plugin] elixir_code  # Basename of a plugin to implement other functions. 
 
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

To Do
=====

Expand plugins to implement a basic find, tripwire, access monitoring, etc.. 