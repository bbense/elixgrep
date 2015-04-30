defmodule BenchHash do
  use Benchfella

  @lengths [1024,2048,4096,8192,16384,32768,65536,131072,262144,524288,1048576,2097152,4194304]
  
  for chunk <- @lengths do 
   	@chunk chunk 
    bench "Hash 1 mega file by #{Integer.to_string(@chunk)}" do
      0..9 |> Enum.map( fn(_) -> hash_test(@chunk) end )
    end
  end 

  def hash_test(chunk) do
   File.stream!("./bench/data_2_24",[],chunk) 
   |> 
    Enum.reduce(:crypto.hash_init(:sha256),fn(line, acc) -> acc = :crypto.hash_update(acc,line) end ) 
   |> 
    :crypto.hash_final 
   |> 
    Base.encode16 
  end 

  # bench "Hash 2**22 file by 2048 " do
  #  0..9 |> Enum.map( fn(_) -> hash_test(2048) end )
  # end

  # bench "Hash 2**22 file by 8192 " do 
  #   0..9 |> Enum.map( fn(_) -> hash_test(8192) end )
  # end

  # bench "Hash 2**22 file by 65536 " do
  #  0..9 |> Enum.map( fn(_) -> hash_test(65536) end )
  # end

  
  # bench "Hash 2**22 file by 131072" do
  #   0..9 |> Enum.map( fn(_) -> hash_test(131072) end )
  # end

  # bench "Hash 2**22 file by 524288" do
  #   0..9 |> Enum.map( fn(_) -> hash_test(524288) end )
  # end


end