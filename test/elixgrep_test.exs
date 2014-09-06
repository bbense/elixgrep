defmodule ElixgrepTest do
  use ExUnit.Case

  test "Elixgrep.fgrep works with small chunksize" do
  	assert Elixgrep.fgrep("README.md","Elix",2) == ["Elixgrep\n"]
  end 
  
   test "Elixgrep.fgrep works with chunksize larger than file" do
  	assert Elixgrep.fgrep("README.md","Elix",200) == ["Elixgrep\n"]
  end 
  

end
