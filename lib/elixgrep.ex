defmodule Elixgrep do
	
	#Search a file for a string
	def fgrep(path,string) do
		File.stream!(path) 
	|> 
		Parallel.pmap(fn (line) ->  if( String.contains?(line,string), do: line ) end) 
	|>
		Enum.filter( fn(x) -> x end )
	end 

end
