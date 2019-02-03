defmodule DycProcessorTest do
  use ExUnit.Case

  import Dyc.DycProcessor

  @test_code [
    %{
      "file" => "./test/data/py_code/routes/route.py", 
      "function" => "index()", 
      "line" => 1
    }, 
    %{
      "file" => "./test/data/py_code/routes/route.py", 
      "function" => "del_todo(todo_id)", 
      "line" => 7
    }, 
    %{
      "file" => "./test/data/py_code/service.py", 
      "function" => "create_app(config_name=None)", 
      "line" => 0
    }
  ]
  @test_usage [
    %{
      "count" => "100",
      "file" => "service.py",
      "function" => "run()",
      "line" => "42"
    },
    %{
      "count" => "10",
      "file" => "service.py",
      "function" => "start_cache()",
      "line" => "40"
    }
  ] 
  @test_project "./test/data/py_code"
  @test_file "./test/data/usage.csv"

  @doc """
  Component test
  """
  test "process files concurrently" do
    assert process_files({@test_file, @test_project}, {}) ==
      {@test_usage, @test_code}
  end
end
