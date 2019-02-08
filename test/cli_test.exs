defmodule CliTest do
  use ExUnit.Case

  import Dyc.CLI
  import ExUnit.CaptureIO

  test ":help returned by option parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
    assert parse_args(["--help", "anything"]) == :help
  end

  test "two values returned if two given" do
    assert parse_args(["./", "./.gitignore"]) == {"./", "./.gitignore"}
  end

  test "error returned if one value given" do
    assert parse_args(["./", "./file.csv"]) == :error
  end

  test "two paths returned if existing two given" do
    assert check_args({"./", "./.gitignore"}) == {"./", "./.gitignore"}
  end

  test "error returned if non existing two given" do
    assert check_args({"some/path/to/file/", "./file.csv"}) == :error
  end

  test "non processing responses" do
    help_execution = fn -> process(:help) end
    error_execution = fn -> process(:error) end
    assert capture_io(help_execution) =~ "Usage: dyc <code_path> <csv_file>"
    assert capture_io(error_execution) =~ "Error: input arguments are not valid."
  end

  test "sanitize offset" do
    data = 1..13 |> Enum.to_list
    assert sanitize_offset(data, 0, 10) == 0
    assert sanitize_offset(data, -10, 10) == 0
    assert sanitize_offset(data, 10, 10) == 10
    assert sanitize_offset(data, 20, 10) == 10
  end

end