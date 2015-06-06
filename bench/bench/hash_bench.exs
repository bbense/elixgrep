defmodule Hash do
  use Benchfella

  @lengths [1024,2048,4096,8192,16384,32768,65536,131072,262144,524288,1048576,2097152,4194304,8388608,16777216]
  
  for chunk <- @lengths do 
   	@chunk chunk 
    bench "Hash 2**24 file by #{Integer.to_string(@chunk)}" do
      hash_test("./bench/data_2_24",@chunk) 
    end
  end 

  for chunk <- @lengths do 
    @chunk chunk 
    bench "Hash 2**26 file by #{Integer.to_string(@chunk)}" do
      hash_test("./bench/data_2_26",@chunk)
    end
  end 

  for chunk <- @lengths do 
    @chunk chunk 
    bench "Hash 2**28 file by #{Integer.to_string(@chunk)}" do
      hash_test("./bench/data_2_28",@chunk)
    end
  end 


  def hash_test(file,chunk) do
   File.stream!(file,[],chunk) 
   |> 
    Enum.reduce(:crypto.hash_init(:sha256),fn(line, acc) -> :crypto.hash_update(acc,line) end ) 
   |> 
    :crypto.hash_final 
   |> 
    Base.encode16 
  end 

  

end