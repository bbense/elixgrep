defmodule ElixgrepPlugin do
  use Timex

  @moduledoc """
  This is a plugin to duplicate some of the functionality of the find command. 
  It also demonstrates how a plugin can use the wildcard command line options.
  The syntax is as follows 

      --plugin find --atime file_or_parsable_time_string [verb] [paths or files]
  
  For time based attributes the verbs are older, newer, around 
  The default range for around is 24hrs, use `--delta seconds` to change it. 
  For now it just supports the time based parameters in File.Stat
      [ atime, ctime, mtime ]

  Without any additional arguments it assumes the verb is a string regexp
  and matchs the basename against the regexp. 

  * ToDo: Figure out how to have -h in the main program call help in the plugin. 
  * ToDo: Add parsable time string parsing.
  * ToDo: Add find style delta parsing

         Possible time units are as follows:

             s       second
             m       minute (60 seconds)
             h       hour (60 minutes)
             d       day (24 hours)
             w       week (7 days)

         Any number of units may be combined in one `--delta` argument, for example, `--delta 1h30m`.  
  """

  @default_delta 86400

  @doc """
  The gr_reduce function collects the results of applying gr_map to each file. 
  The results parameter in the item bracket is exactly the output from the gr_map function on the 
  given file path. 
  """
  def gr_reduce(options) do 
        receive do
          { :item, path, results } ->  
            results |> Enum.map(fn(str) -> IO.puts("#{path}: #{str}") end )
            gr_reduce(options)

          { :finalize } -> 
            IO.puts("Signing off from find plugin")
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
    
    case string do 
      "older"  -> compare_time(fn(a,b) -> a > b end,options,path)
      "newer"  -> compare_time(fn(a,b) -> a < b end,options,path)
      "around" -> compare_time(fn(a,b) -> around(options,a,b) end,options,path)
      _        -> match_name(options,path)
    end 
    |> if( do: [string], else: [] )
  end

  def match_name(options,path) do
    %{ search: string } = options 
    re = Regex.compile!(string)
    Regex.match?(re,Path.basename(path))
  end 

  def compare_time(judge,options,path) do
    case options do 
     %{ atime: arg } -> judge.(file_time(arg,:atime),file_time(path,:atime))
     %{ ctime: arg } -> judge.(file_time(arg,:ctime),file_time(path,:ctime))
     %{ mtime: arg } -> judge.(file_time(arg,:mtime),file_time(path,:mtime))
     _               -> raise "compare_time called w/o time choice in #{inspect options}"
    end 

  end 

  def around(options,a,b) do 
    case options do 
      %{ delta: interval } -> value = String.to_integer(interval)
      _                    -> value = @default_delta
    end 
    if(abs(a - b) < value , do: true , else: false )
  end 

  def file_time(path,time_value) do
    File.stat!(path,[time: :posix])
    |> Map.get(time_value)
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