ExUnit.start()

File.touch("test_data/file2")
# Make sure file2 is older
:timer.sleep(2000)