

# The idea is to read a file into a stream and spawn a process for each line in the file to 
# search for a string. 

defmodule Parallel do
  def pmap(collection, fun) do
    me = self
 
    collection
  |>
    Enum.map(fn (elem) ->
       spawn_link fn -> (send me, { self, fun.(elem) }) end
     end)
  |> 
    Enum.map(fn (pid) ->
      receive do { ^pid, result } -> result end
    end)
  end
end

defmodule PGrep do

	#Search a file for a string
	def fgrep(path,string) do
		File.stream!(path) |> Parallel.pmap fn (line) ->  if( String.contains?(line,string), do: line ) end |> Enum.filter fn (line) -> line end
	end 


end