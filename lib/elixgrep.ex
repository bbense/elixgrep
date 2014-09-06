defmodule Elixgrep do

	#Search a file for a string
	def fgrep(path,string) do
		File.stream!(path) 
	|> 
		Parallel.pmap(fn (line) ->  if( String.contains?(line,string), do: line ) end) 
	|>
		Enum.filter( fn(x) -> x end )
	end 

	def main(args) do
    	args |> parse_args |> process
  end
 
  def parse_args(args) do
    options = OptionParser.parse(args, switches: [help: :boolean],
                                      aliases: [h: :help])
    case options do
      { [ help: true], _, _}      -> :help
      { _, args, _ }              -> args
      _                           -> :help
    end
  end
 
  def process([string,path]) do
  	fgrep(path,string) |> Enum.map(fn(str) -> IO.write("#{path}: #{str}") end )
  end 

  def process([head | tail]) do 
     tail |> Parallel.pmap( fn (path) -> process([head,path]) end)
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
