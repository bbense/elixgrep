defmodule ElixgrepPlugin do
  
  @module_doc """
  This is a plugin to duplicat some of the functionality of the find command. 
  It also demonstrates how a plugin can use the wildcard command line options. 
  """

  @doc """
  The gr_reduce function collects the results of applying gr_map to each file. 
  The results parameter in the item bracket is exactly the output from the gr_map function on the 
  given file path. 
  """
  def gr_reduce(options) do 
        receive do
          { :item, path, results } ->  
            results |> Enum.map(fn(str) -> IO.write("#{path}: #{str}") end )
            gr_reduce(options)

          { :finalize } -> 
            IO.puts("Singing off from grep plugin")
            send options.master_pid, { :all_done_boss }
            exit(:normal)

        end 
  end 

  @doc """
  elixgrep runs this function in parallel on every file in it's expanded
  pathlist. The search string is always the first string in the cmd line that is 
  not an arg.
  """
  def gr_map(options,path) do
    %{ search: string } = options 
      File.stat!(path)
    
  end 

# iex(48)st = %File.Stat{access: :read_write, atime: {{2014, 9, 17}, {13, 50, 51}},
#  ctime: {{2014, 9, 16}, {13, 41, 41}}, gid: 501, inode: 44370747, links: 17,
#  major_device: 16777218, minor_device: 0, mode: 16877,
#  mtime: {{2014, 9, 16}, {13, 41, 41}}, size: 578, type: :directory, uid: 501}
# iex(49)> st.access
# :read_write
# iex(50)> st.atime
# {{2014, 9, 17}, {13, 50, 51}}

end 