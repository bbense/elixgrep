defmodule ElixgrepTest do
  use ExUnit.Case
  #import ExUnit.CaptureIO  
  
  # Does weird things. Seems to swallow any output errors.
  # test "-h returns module_doc" do 
  #   assert capture_io( fn ->
  #      Elixgrep.main(["-h"])
  #    end 
  #     ) == "Usage:"
  # end 

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

  test "Custom args are parsed correctly" do
    {opts,args} = Elixgrep.parse_args(["-a","atime","fred", "/tmp/bar", "/tmp/foo"]) 
    assert opts.a ==  "atime"
    assert args == ["fred","/tmp/bar","/tmp/foo"] 
  end
  
  test "build_paths returns correct values" do
    {options,[ target | files ] } = Elixgrep.build_paths({%{:count => 1000},["fred","./test"]}) 
    assert options.count == 1000
    assert target == "fred"
    tfiles = ["./test/test_helper.exs", "./test/elixgrep_test.exs","./test/plugin_test.exs","./test/dirtree_test.exs"]
    assert Enum.sort(tfiles) == Enum.sort(files)
  end 

  test "rehabilitate_args returns an option map" do 
    bad_args = [{"-p", "people"}, {"-v", nil},{"--type","bad"}]
    good_opts = [p: "people", v: true, type: "bad"]
    assert good_opts == Elixgrep.rehabilitate_args(bad_args)
  end 

  test "Eligrep.gr_map works" do
    opts = %{ search: "Elix"}
    path = "README.md"
    assert Elixgrep.gr_map(opts,path) == ["Elixgrep\n"]
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
