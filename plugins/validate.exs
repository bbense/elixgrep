defmodule EgPlugin.Validate do
  
  @moduledoc """
  This is a plugin computes a checksum of all the files and compares it to a list
  of known checksums. 
  The syntax is as follows 

      --plugin validate --first --checksum file [paths or files]
  
    ToDo: Add options for checksum and salt. 
  """

  @doc """
  The gr_reduce function collects the results of applying gr_map to each file. 
  The results parameter in the item bracket is exactly the output from the gr_map function on the 
  given file path. 
  """
  def gr_reduce(options) do 
        # Start Agent to read existing data

        # Start Reciever loop 
        reduce_loop(new_options)
  end 

  defp reduce_loop(options) do 
        receive do
          { :item, path, results } ->  
            results |> Enum.map(fn(str) -> IO.puts("#{path}: #{str}") end )
            reduce_loop(options)

          { :finalize } -> 
            IO.puts("Signing off from Validate plugin")
            send options.master_pid, { :all_done_boss }
            exit(:normal)
        end 
  end 

  @doc """
  elixgrep runs this function in parallel on every file in it's expanded
  pathlist. It should return the type expected in results in the recieve
  loop in gr_reduce. 
  """
  def gr_map(options,path) do
    
  end

  
end 