

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

