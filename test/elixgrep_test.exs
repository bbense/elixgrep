defmodule ElixgrepTest do
  use ExUnit.Case
  #import ExUnit.CaptureIO  
 
  test "count is set to default w/o -c" do
    {opts,args} = Elixgrep.parse_args(["fred", "/tmp/bar", "/tmp/foo"]) 
    assert opts.count ==  512
    assert args == ["fred","/tmp/bar","/tmp/foo"] 
  end
  
  test "count is set with -c" do
    {opts,args} = Elixgrep.parse_args(["--count","10000","fred", "/tmp/bar", "/tmp/foo"]) 
    assert opts.count ==  10000
    assert args == ["fred","/tmp/bar","/tmp/foo"] 
  end
  
  test "build_paths returns correct values" do
    {options,[ target | files ] } = Elixgrep.build_paths({%{:count => 1000},["fred","./test"]}) 
    assert options.count == 1000
    assert target == "fred"
    tfiles = ["./test/test_helper.exs", "./test/elixgrep_test.exs","./test/dirtree_test.exs"]
    assert Enum.sort(tfiles) == Enum.sort(files)
  end 

  test "Eligrep.gr_map works" do
    opts = %{ search: "Elix"}
    path = "README.md"
    path_stream = File.stream!(path)
    assert Elixgrep.gr_map(opts,path,path_stream) == ["Elixgrep\n"]
  end 

  # Tried 80 different ways to get this test to actually run.
  # Clearly there is something here I don't understand. 
  # test "Elixgrep.gr_reduce prints strings" do
  #   pid = spawn_link(fn ->Elixgrep.gr_reduce([]) end)
  #   assert capture_io( 
  #     send pid, { :item ,"README.md",["Elixgrep\n"] }
  #   ) == "README.md: Elixgrep\n"
  # end 

end
