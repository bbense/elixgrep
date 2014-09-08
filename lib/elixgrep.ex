defmodule Elixgrep do

  @module_doc """
      Usage:
        exilgrep [string] [files and/or directories]
 
      Options:
        -h, [--help]                # Show this help message and quit.
        -c, [--chunksize] linecount # Number of lines to search per process.
 
      Description:
        Prints all the lines in file containing string
    """


  @default_chunksize 1000
  @max_ofiles 512

	#Search a file for a string
	def fgrep(path,string,chunksize) do
    File.stream!(path)
  |>
		Stream.chunk(chunksize,chunksize,[])
	|> 
		Parallel.pmap(fn(lines) -> lgrep(lines,string) end  ) 
	|>
		List.flatten
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
