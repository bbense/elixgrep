defmodule DirTree do

	def files(path_list) do
		Enum.filter(path_list, fn(pth) -> File.regular?(pth) end ) 
	end 

	def dirs(path_list) do
		Enum.filter(path_list, fn(pth) -> File.dir?(pth) end) 
	end 
	
end