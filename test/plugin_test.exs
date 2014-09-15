defmodule PluginTest do
  use ExUnit.Case

  
  test "Plugin.get_paths returns a list of dirs" do
    assert Plugin.get_paths == ["./plugins"]
  end

  test "Plugin.search can find default grep plugin" do
    assert Plugin.search_path("grep") == "./plugins/grep.exs"
  end
  
  # test "Plugin.load defines a module" do 
  #   Plugin.load("grep")
  #   assert Code.loaded_files
  # end 
  
end
