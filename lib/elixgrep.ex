defmodule Elixgrep do

  @default_chunksize 1000

	#Search a file for a string
	def fgrep(path,string,chunksize) do
    File.stream!(path)
  |>
		Enum.chunk(chunksize,chunksize,[])
	|> 
		Parallel.pmap(fn (lines) -> lgrep(lines,string) end  ) 
	|>
		List.flatten
	end 

  def lgrep(lines,string) do
      lines
    |>
      Enum.filter( fn(line) -> String.contains?(line,string) end) 
  end 

	def main(args) do
    	args |> parse_args |> process
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
 
  def process({chunksize,[string,path]}) do
  	fgrep(path,string,1000) |> Enum.map(fn(str) -> IO.write("#{path}: #{str}") end )
  end 

  def process({chunksize,[head | tail]}) do 
     tail |> Parallel.pmap( fn (path) -> process({chunksize,[head,path]}) end)
  end 
 
  def process(:help) do
    IO.puts """
      Usage:
        exilgrep [string] [file]
 
      Options:
        -h, [--help]      # Show this help message and quit.
 
      Description:
        Prints all the lines in file containing string
    """
    System.halt(0)
  end

end
