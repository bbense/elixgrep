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
  test "ElixgrepPlugin.gr_map newer mtime fails when target older" do
   options = %{ search: "newer" , mtime: "./test_data/file1" }
   path = "./test_data/file2"
   assert [] == ElixgrepPlugin.gr_map(options,path)
  end

  test "ElixgrepPlugin.gr_map newer mtime succedes when target newer" do
   options = %{ search: "newer" , mtime: "./test_data/file2" }
   path = "./test_data/file1"
   assert ["newer"] == ElixgrepPlugin.gr_map(options,path)
  end

  test "ElixgrepPlugin.gr_map older mtime succedes when target older" do
   options = %{ search: "older" , mtime: "./test_data/file1" }
   path = "./test_data/file2"
   assert ["older"] == ElixgrepPlugin.gr_map(options,path)
  end

  test "ElixgrepPlugin.gr_map older time fails when target older" do
   options = %{ search: "older" , mtime: "./test_data/file2" }
   path = "./test_data/file1"
   assert [] == ElixgrepPlugin.gr_map(options,path)
  end

  test "ElixgrepPlugin.gr_map around mtime succedes when target older" do
   options = %{ search: "around" , mtime: "./test_data/file1" }
   path = "./test_data/file2"
   assert ["around"] == ElixgrepPlugin.gr_map(options,path)
  end

  test "ElixgrepPlugin.gr_map can search names via regexp" do
   options = %{ search: "file.*"  }
   path = "./test_data/file2"
   assert ["file.*"] == ElixgrepPlugin.gr_map(options,path)
  end

  
 
end
