defmodule Elixgrep do

  @moduledoc """
      Usage:
        exilgrep [string] [files and/or directories]

      Options:
        -h, [--help]                # Show this help message and quit.
        -c, [--count] filecount     # Number of files to process in parallel

      Description:

        Runs a version of map/reduce on the file list given on the command
        line. Requires an elixir module that implements two functions.

        gr_map(options,path) -> {path,[]}
        gr_reduce(options) Expects to recieve two kinds of messages
                    { item: { path, []}}
                    { finalize: } -> Should output results and exit.
    """

  @ofiles_per_core 8
  @plugin_path ["./plugins"]
  @plugin_funcs [gr_reduce: 1, gr_map: 2]

  def processing_units, do: :erlang.system_info(:logical_processors)

  require DirWalker

  def gr_reduce(options) do
        receive do
          { :item, path, results } ->
            results |> Enum.map(fn(str) -> IO.write("#{path}: #{str}") end )
            gr_reduce(options)

          { :finalize } ->
            send options.master_pid, { :all_done_boss }
            exit(:normal)

        end
  end

  def gr_map(options,path) do
    %{ search: string } = options
      File.stream!(path)
    |>
      Stream.filter(fn(line) -> String.contains?(line,string) end )
    |>
      Enum.map( fn(x) -> x end )
  end

  def start_reduce(options) do
    spawn_link(fn -> options.reduce_func.(options) end)
  end

  def main(args) do
      args |> parse_args |> build_paths |> background |> process |> cleanup
  end

  def merge_opts(opts,bad_opts) do
    bad_opts |>  rehabilitate_args |> Keyword.merge(opts)
  end

  def parse_args(args) do
    options = %{ :count => @ofiles_per_core * processing_units ,
                 :map_func => fn(opt,path) -> gr_map(opt,path) end ,
                 :reduce_func => fn(opt) -> gr_reduce(opt) end }

    cmd_opts = OptionParser.parse(args,
                                  switches: [help: :boolean , count: :integer, plugin: :string],
                                  aliases: [h: :help, c: :count, p: :plugin])

    case cmd_opts do
      { [ help: true], _, _}   -> :help
      { [], args, [] }         -> { options, args }
      { opts, args, [] }       -> { Enum.into(opts,options), args }
      { opts, args, bad_opts}  -> { Enum.into(merge_opts(opts,bad_opts),options), args}
      _                        -> :help
    end
  end

  def rehabilitate_args(bad_args) do
      bad_args
     |>
      Enum.flat_map(fn(x) -> Tuple.to_list(x) end)
     |>
      Enum.filter_map(fn(str) -> str end, fn(str) -> String.replace(str, ~r/^\-([^-]+)/, "--\\1") end )
     |>
      OptionParser.parse
     |>
      Tuple.to_list
     |>
      List.first
  end

  # Avoid expanding the stream.
  def build_paths({options,[head | tail]}) do
     next_opts = options |> Map.put(:search,head)
    { next_opts, DirWalker.stream(tail) }
  end

  def build_paths(:help) do
    IO.puts @moduledoc
    System.halt(0)
  end

  def background({options,filestream}) do
    if(Map.has_key?(options,:plugin), do: next_opt = load_plugin(options), else: next_opt = options)
    reduce_opts = Map.put(next_opt,:master_pid,self())
    pid = start_reduce(reduce_opts)
    {next_opt |> Map.put(:reduce_pid,pid), filestream }
  end

  def process({options,[path]}) do
    send options.reduce_pid, { :item,path,options.map_func.(options,path) }
    options
  end

  def process({options,filestream}) do
     filestream
    |>
      Stream.chunk(options.count,options.count,[])
    |>
      Enum.map(fn(filelist) -> Parallel.pmap(filelist, fn(path) -> process({options,[path]}) end ) end )
    send options.reduce_pid, { :finalize }
  end

  def cleanup({ :finalize }) do
    receive do
      { :all_done_boss } ->
        System.halt(0)
    end
  end

  # We really need the options in this version.
  def cleanup(options) do
    send options.reduce_pid, { :finalize }
    receive do
       { :all_done_boss } ->
        System.halt(0)
    end
  end

  # Will fail with match error, which is sub-optimal
  def load_plugin(options) do
    {:ok, plugin } = Pluginator.load_with_signature(options.plugin,@plugin_funcs,@plugin_path)
    new_opts = %{
                 :map_func => fn(opt,path) -> plugin.gr_map(opt,path) end ,
                 :reduce_func => fn(opt) -> plugin.gr_reduce(opt) end }
    Map.merge(options,new_opts)
  end

end
