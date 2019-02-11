defmodule DycProcessorTest do
  use ExUnit.Case

  import Dyc.DycProcessor

  @test_result [
    %{
      "count" => 10,
      "file" => "./test/data/py_code/routes/route.py",
      "function" => "index()",
      "line" => 1
    },
    %{
      "count" => 0,
      "file" => "./test/data/py_code/routes/route.py",
      "function" => "del_todo(todo_id)",
      "line" => 7
    },
    %{
      "count" => 7,
      "file" => "./test/data/py_code/utils/cache.py",
      "function" => "clean_cache()",
      "line" => 0
    },
    %{
      "count" => 100,
      "file" => "./test/data/py_code/service.py",
      "function" => "create_app(config_name=None)",
      "line" => 0
    }
  ]
  @test_project "./test/data/py_code"
  @test_file "./test/data/usage.csv"

  @doc """
  Component test
  """
  test "process files" do
    assert Enum.sort(process({@test_project, @test_file})) == Enum.sort(@test_result)
  end
end
