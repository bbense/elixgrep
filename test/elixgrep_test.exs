defmodule ElixgrepTest do
  use ExUnit.Case

  test "Elixgrep.fgrep" do
  	assert Elixgrep.fgrep("README.md","Elix") == ["Elixgrep\n"]
  end 
  
  
end
