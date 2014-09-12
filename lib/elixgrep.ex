defmodule Elixgrep do

  @module_doc """
      Usage:
        exilgrep [string] [files and/or directories]
 
      Options:
        -h, [--help]                # Show this help message and quit.
        -c, [--chunksize] linecount # Number of lines to search per process.
 
      Description:
        
        Runs a version of map/reduce on the file list given on the command
        line. Requires an elixir module that implements two functions. 

        gr_map(options,path,Enum) -> {path,[]}
        gr_reduce(options) Expects to recieve two kinds of messages 
                    { item: { path, []}}
                    { finalize: } -> Should output results and exit.
    """


  @default_chunksize 1000
  @max_ofiles 512

  def gr_reduce(options) do 
        receive do
          { :item, path, results } ->  
              results 
            |>
              Enum.map(fn(str) -> IO.write("#{path}: #{str}") end )
            gr_reduce(options)

          { :finalize } -> 
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

  def fgrep(path,string,_chunksize) do
    File.stream!(path)
   |>
    Stream.filter(fn(line) -> String.contains?(line,string) end )
   |> 
    Enum.map( fn(x) -> x end )
   
  end 

  def lgrep(lines,string) do
      lines
    |>
      Enum.filter( fn(line) -> String.contains?(line,string) end) 
  end 

	def main(args) do
    	args |> parse_args |> build_paths |> process
  end
 
  def parse_args(args) do
    options = OptionParser.parse(args, switches: [help: :boolean , chunksize: :integer],
                                      aliases: [h: :help, c: :chunksize])
    case options do
      { [ help: true], _, _}            -> :help
      { [chunksize: count], args, _ }   -> { count, args }
      { [], args, _ }                   -> { @default_chunksize, args }
      _                                 -> :help
    end
  end

  def build_paths({chunksize,[head | tail]}) do
    {chunksize,Enum.concat([ head ] ,DirTree.expand(tail))}
  end 
 
  def process({chunksize,[string,path]}) do
  	fgrep(path,string,chunksize) |> Enum.map(fn(str) -> IO.write("#{path}: #{str}") end )
  end 

  def process({chunksize,[head | tail]}) do 
     tail
    |> 
      Enum.chunk(@max_ofiles,@max_ofiles,[])
    |>
      Enum.map(fn(filelist) -> Parallel.pmap(filelist, fn(path) -> process({chunksize,[head,path]}) end ) end )
  end 
 
  def process(:help) do
    IO.puts @module_doc
    System.halt(0)
  end

end
