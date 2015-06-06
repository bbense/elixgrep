defmodule ValidatePluginTest do
  use ExUnit.Case

  setup_all do
     {:ok, test_plugin } = Pluginator.load_with_signature("validate",[gr_map: 2],["./plugins"])
     {:ok, test_plugin: test_plugin }
  end 

  
  test "EgPlugin.Validate.gr_map computes hash when file < chunk", context do
    options = %{}
    path = "./test_data/file2"
    assert "339CA9999C1549244EADD7FB1F5B667429D9C5A5621A4180C3CA28A7CA0409C0" == context[:test_plugin].gr_map(options,path)
  end

  test "EgPlugin.Validate.gr_map computes hash when file > chunk", context do
    options = %{}
    path = "/tmp/validate.testdata"
    make_big_testfile(path)
    assert "0FC9C3571CF4693254689E6B814B7BC9ED290C049472F659649DDC1FC7D45857" == context[:test_plugin].gr_map(options,path)
    File.rm(path)
  end
  
  defp make_big_testfile(path) do
    Stream.cycle(["a"]) |> Stream.into(File.stream!(path,[],1)) |> Enum.take(512000)
  end
 
end
