defmodule FindPluginTest do
  use ExUnit.Case

  setup_all do
     {:ok, test_plugin } = Pluginator.load_with_signature("find",[gr_map: 2],["./plugins"])
     {:ok, test_plugin: test_plugin }
  end 

  setup do
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
  test "EgPlugin.Find.gr_map newer mtime fails when target older", context do
   options = %{ search: "newer" , mtime: "./test_data/file1" }
   path = "./test_data/file2"
   assert [] == context[:test_plugin].gr_map(options,path)
  end

  test "EgPlugin.Find.gr_map newer mtime succedes when target newer", context do
   options = %{ search: "newer" , mtime: "./test_data/file2" }
   path = "./test_data/file1"
   assert ["newer"] == context[:test_plugin].gr_map(options,path)
  end

  test "EgPlugin.Find.gr_map older mtime succedes when target older", context do
   options = %{ search: "older" , mtime: "./test_data/file1" }
   path = "./test_data/file2"
   assert ["older"] == context[:test_plugin].gr_map(options,path)
  end

  test "EgPlugin.Find.gr_map older time fails when target older", context do
   options = %{ search: "older" , mtime: "./test_data/file2" }
   path = "./test_data/file1"
   assert [] == context[:test_plugin].gr_map(options,path)
  end

  test "EgPlugin.Find.gr_map around mtime succedes ", context do
   options = %{ search: "around" , mtime: "./test_data/file1" }
   path = "./test_data/file2"
   assert ["around"] == context[:test_plugin].gr_map(options,path)
  end

  test "EgPlugin.Find.gr_map can search names via regexp", context do
   options = %{ search: "file.*"  }
   path = "./test_data/file2"
   assert ["file.*"] == context[:test_plugin].gr_map(options,path)
  end

  
 
end
