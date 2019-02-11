defmodule UsageScraperTest do
  use ExUnit.Case

  import Dyc.UsageScraper
  import ExUnit.CaptureIO

  @test_map [
    %{
      "count" => "100",
      "file" => "./test/data/py_code/service.py",
      "function" => "create_app(config_name=None)",
      "line" => "0"
    },
    %{
      "count" => "10",
      "file" => "./test/data/py_code/routes/route.py",
      "function" => "index()",
      "line" => "1"
    },
    %{
      "count" => "7",
      "file" => "./test/data/py_code/utils/cache.py",
      "function" => "clean_cache()",
      "line" => "0"
    }
  ]
  @test_file "./test/data/usage.csv"

  @doc """
  Component test
  """
  test "scrap .csv file concurrently" do
    scrap_file(self(), @test_file, :csv)
    receive do
      {_pid, data} -> assert Enum.sort(data) == Enum.sort(@test_map)
      after 1000 -> assert 0 == @test_map
    end
  end

  @doc """
  Unit tests
  """
  test "check map that is valid" do
    assert check_maps(@test_map) == {:ok, @test_map}
  end
  
  test "check map that is not valid" do
    map = [
      %{
        "count" => "100",
        "file" => "service.py",
        "function" => "run()",
      },
      %{
        "count" => "10",
        "file" => "service.py",
        "function" => "start_cache()",
        "line" => "40"
      },
      %{
        "count" => "7",
        "file" => "./test/data/py_code/utils/cache.py",
        "function" => "clean_cache()",
        "line" => "0"
      }
    ]
    assert check_maps(map) == {:error, map}
  end

  test "decode file stream to list" do
    result = @test_file |> File.stream! |> decode_file(:csv)
    assert result == @test_map
  end

  test "decode error result" do
    error_execution = fn -> decode_result({:error, []}) end
    assert capture_io(error_execution) =~ "Error: .CSV file is not valid."
  end

  test "scrap .csv file" do
    assert scrap_file(@test_file, :csv) == @test_map
  end
  
end