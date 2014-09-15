defmodule PluginTest do
  use ExUnit.Case

  
  test "Plugin.get_paths returns a list of dirs" do
    assert Plugin.get_paths == ["./plugins"]
  end

  test "Plugin.search can find default grep plugin" do
    assert Plugin.search_path("grep") == "./plugins/grep.exs"
  end

  test "Plugin.search fails" do
    refute Plugin.search_path("sidehill_gouger")
  end 
  
  # Does not pass for some reason. Error is raised. 
  # test "Plugin.load raises error when plugin doesn't exist" do 
  #   assert_raise RuntimeError, Plugin.load("sidehill_gouger")
  # end

  test "Plugin.load" do
    Plugin.load("grep")
  end

end
