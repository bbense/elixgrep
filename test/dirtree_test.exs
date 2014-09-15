defmodule DirTreeTest do
  use ExUnit.Case

  
  test "DirTree.files returns files" do
    path = ["/tmp","README.md"]
    assert DirTree.files(path) == ["README.md"]
  end

  test "DirTree.dirs returns dirs" do
    path = ["/tmp","README.md"]
    assert DirTree.dirs(path) == ["/tmp"]
  end

  test "DirTree.expand returns files in subdir" do
    path = ["./test","README.md"]
    ex_path = ["./test/dirtree_test.exs","./test/elixgrep_test.exs","./test/plugin_test.exs","./test/test_helper.exs","README.md"]
    assert Enum.sort(DirTree.expand(path)) == ex_path
  end

end
