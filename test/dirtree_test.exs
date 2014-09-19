defmodule DirTreeTest do
  use ExUnit.Case, async: true

  
  test "DirTree.files returns files" do
    path = ["./test_data","README.md"]
    assert DirTree.files(path) == ["README.md"]
  end

  test "DirTree.dirs returns dirs" do
    path = ["./test_data","README.md"]
    assert DirTree.dirs(path) == ["./test_data"]
  end

  test "DirTree.expand returns files in subdir" do
    path = ["./test_data","README.md"]
    ex_path = ["./test_data/file1","./test_data/file2","./test_data/subdir/file3","README.md"]
    assert Enum.sort(DirTree.expand(path)) == ex_path
  end

end
