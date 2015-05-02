defmodule SmallFileHash do
  use Benchfella

  
  bench "Hash small file with chunk size larger than file" do
      0..9 |> Enum.map( fn(_) -> hash_chunk("./bench/small_file",32000) end )
  end
  
  bench "Hash small file with with simple read" do
      0..9 |> Enum.map( fn(_) -> hash_simple("./bench/small_file") end )
  end
  

  def hash_chunk(file,chunk) do
   File.stream!(file,[],chunk) 
   |> 
    Enum.reduce(:crypto.hash_init(:sha256),fn(line, acc) -> acc = :crypto.hash_update(acc,line) end ) 
   |> 
    :crypto.hash_final 
   |> 
    Base.encode16 
  end 

  def hash_simple(file) do 
    :crypto.hash(:sha256,File.read!(file)) |> Base.encode16 
  end 
  

end