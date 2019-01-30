defmodule CsvProcessorTest do
  use ExUnit.Case

  import Dyc.CSVProcessor, only: [process_file: 1]

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
  end
  
end