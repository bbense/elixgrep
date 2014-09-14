defmodule DirTree do

  def files(path_list) do
    Enum.filter(path_list, fn(pth) -> File.regular?(pth) end ) 
  end 

  def dirs(path_list) do
    Enum.filter(path_list, fn(pth) -> File.dir?(pth) end) 
  end 
  
  def entries(dir) do
    {:ok,elist} = File.ls(dir)
    Enum.map(elist, fn(entry) -> "#{dir}/#{entry}" end)
  end 

  def expand([]), do: [] 

  def expand(path_list) do
    myfiles = files(path_list)
    mydirs = dirs(path_list)
      Enum.flat_map(mydirs, fn(dir) -> entries(dir) end )
    |> 
      expand
    |>
      Enum.concat(myfiles)
  end 

  # Not needed for exilgrep, but would be useful. 
  # Just replace all Enums above with streams?
  # def stream(dir)
  #
  # end 

end