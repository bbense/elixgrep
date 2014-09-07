defmodule ElixgrepTest do
  use ExUnit.Case

  test "Elixgrep.fgrep works with small chunksize" do
  	assert Elixgrep.fgrep("README.md","Elix",2) == ["Elixgrep\n"]
  end 
  
  test "Elixgrep.fgrep works with chunksize larger than file" do
  	assert Elixgrep.fgrep("README.md","Elix",200) == ["Elixgrep\n"]
  end 
  
	test "chunksize is set to default w/o -c" do
		assert Elixgrep.parse_args(["fred", "/tmp/bar", "/tmp/foo"]) == { 1000, ["fred","/tmp/bar","/tmp/foo"] }
	end
	
	test "chunksize is with -c" do
		assert Elixgrep.parse_args(["--chunksize","10000","fred", "/tmp/bar", "/tmp/foo"]) == { 10000, ["fred","/tmp/bar","/tmp/foo"] }
	end
  
  test "build_paths returns correct values" do
  	{count,[ target | files ] } = Elixgrep.build_paths({1000,["fred","./test"]}) 
  	assert count == 1000
  	assert target == "fred"
  	tfiles = ["./test/test_helper.exs", "./test/elixgrep_test.exs","./test/dirtree_test.exs"]
  	assert Enum.sort(tfiles) == Enum.sort(files)
  end 

end
