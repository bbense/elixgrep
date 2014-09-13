defmodule Elixgrep do

  @module_doc """
      Usage:
        exilgrep [string] [files and/or directories]
 
      Options:
        -h, [--help]                # Show this help message and quit.
        -c, [--count] filecount     # Number of files to process in parallel
 
      Description:
        
        Runs a version of map/reduce on the file list given on the command
        line. Requires an elixir module that implements two functions. 

        gr_map(options,path,Enum) -> {path,[]}
        gr_reduce(options) Expects to recieve two kinds of messages 
                    { item: { path, []}}
                    { finalize: } -> Should output results and exit.
    """

  @max_ofiles 512

  def gr_reduce(options) do 
        receive do
          { :item, path, results } ->  
            results |> Enum.map(fn(str) -> IO.write("#{path}: #{str}") end )
            gr_reduce(options)

          { :finalize } -> 
            IO.puts("\nAll done boss\n")
            exit(:normal)

        end 
  end 

  def gr_map(options,_path,path_stream) do
    %{ search: string } = options 
      path_stream 
    |>
      Stream.filter(fn(line) -> String.contains?(line,string) end )
    |> 
      Enum.map( fn(x) -> x end )
  end 

  def start_reduce(options) do
    spawn_link(fn -> options.reduce_func.(options) end)
  end


  def fgrep(path,string,_chunksize) do
    File.stream!(path)
   |>
    Stream.filter(fn(line) -> String.contains?(line,string) end )
   |> 
    Enum.map( fn(x) -> x end )
   
  end 

  def main(args) do
      args |> parse_args |> build_paths |> background |> process
  end
 
  def parse_args(args) do
    options = %{ :count => @max_ofiles ,
                 :map_func => fn(opt,path,strm) -> gr_map(opt,path,strm) end ,
                 :reduce_func => fn(opt) -> gr_reduce(opt) end }
    cmd_opts = OptionParser.parse(args, switches: [help: :boolean , count: :integer],
                                      aliases: [h: :help, c: :count])
    case cmd_opts do
      { [ help: true], _, _}          -> :help
      { [count: count], args, _ }     -> { Map.put(options,:count,count), args }
      { [], args, _ }                 -> { options, args }
      _                               -> :help
    end
  end

  def build_paths({options,[head | tail]}) do  
    {options,Enum.concat([ head ] ,DirTree.expand(tail))}
  end 

  def background({options,args}) do 
    pid = start_reduce(options)
    next_opt = options |> Map.put(:reduce_pid,pid)
    {next_opt,args}
  end
 
  def process({options,[string,path]}) do
    next_opts = options |> Map.put(:search,string)
    send options.reduce_pid, { :item,path,next_opts.map_func.(next_opts,path,File.stream!(path)) }
  end 

  def process({options,[head | tail]}) do 
     tail
    |> 
      Enum.chunk(options.count,options.count,[])
    |>
      Enum.map(fn(filelist) -> Parallel.pmap(filelist, fn(path) -> process({options,[head,path]}) end ) end )
     send options.reduce_pid, { :finalize }
  end 
 
  def process(:help) do
    IO.puts @module_doc
    System.halt(0)
  end

end
