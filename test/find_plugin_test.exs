defmodule FindPluginTest do
  use ExUnit.Case

  setup do
     Plugin.load("find")
     File.touch("test_data/file1")
  end 
   
  # Stolen from Dave Thomas's blog. 
  # for %{ md: md, html: html } <- StmdTest.Reader.tests do
  #  @md   Enum.join(Enum.reverse(md))
  #  @html Enum.join(Enum.reverse(html))
  #  test "\n--- === ---\n" <> @md <> "--- === ---\n" do
  #    result = Earmark.to_html(@md)
  #    assert result == @html
  #  end
  # end
  
  # This should really be two nested enums on ["mtime","ctime","atime"]
  # and ["newer","older","around"]
  test "ElixgrepPlugin.gr_map can use newer mtime on two files " do
   options = %{ search: "newer" , mtime: "./test_data/file1" }
   path = "./test_data/file2"
   assert ["newer"] == ElixgrepPlugin.gr_map(options,path)
  end

  test "ElixgrepPlugin.gr_map can use newer ctime on two files " do
   options = %{ search: "newer" , ctime: "./test_data/file1" }
   path = "./test_data/file2"
   assert ["newer"] == ElixgrepPlugin.gr_map(options,path)
  end

 
end
