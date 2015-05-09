defmodule EgPlugin.Validate do
  
  @moduledoc """
  This is a plugin computes a checksum of all the files and compares it to a list
  of known checksums. 
  The syntax is as follows 

      --plugin validate --first --hashfile file [paths or files]
  
    ToDo: Add options for checksum and salt. 
  """

  @chunk_size 262144

  @doc """
  The gr_reduce function collects the results of applying gr_map to each file. 
  The results parameter in the item bracket is exactly the output from the gr_map function on the 
  given file path. 
  """
  def gr_reduce(options) do 
        # Start Agent to read existing data
        new_options = initialize(options)
        # Start Reciever loop 
        reduce_loop(new_options)
  end 

  defp reduce_loop(options) do 
        receive do
          { :item, path, results } ->  
            process(path,results)
            reduce_loop(options)

          { :finalize } -> 
            IO.puts("Signing off from Validate plugin")
            finalize(options)
            send options.master_pid, { :all_done_boss }
            exit(:normal)
        end 
  end 

  @doc """
  elixgrep runs this function in parallel on every file in it's expanded
  pathlist. It should return the type expected in results in the recieve
  loop in gr_reduce. 
  """
  def gr_map(options, path) do
      # Benchmarking shows 2**20 is significantly faster on large files.
      # Effectively slurps whole thing for small files. However for small 
      # files hash_simple is roughly 2x faster. 
      size = file_size(path)
      case size < @chunk_size do 
        true -> hash_simple(options, path)
        _    -> hash_chunk(options, path, @chunk_size)
      end 
      
  end

  defp hash_chunk(_,file, chunk) do
   File.stream!(file, [], chunk) 
   |> 
    Enum.reduce(:crypto.hash_init(:sha256), fn(line, acc) -> :crypto.hash_update(acc, line) end ) 
   |> 
    :crypto.hash_final 
   |> 
    Base.encode16 
  end 

  defp hash_simple(_,file) do 
    :crypto.hash(:sha256,File.read!(file)) |> Base.encode16 
  end

  def file_size(path) do
    File.stat!(path, [time: :posix])
    |> Map.get(:size)
  end 

  defp initialize(options) do
    options
  end 
  
  defp finalize(options) do
    options 
  end 

  defp process(path,results) do
    { path, results } 
  end 

end 