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

end
