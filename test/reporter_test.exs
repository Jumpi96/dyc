defmodule ReportTest do
  use ExUnit.Case

  import Dyc.Reporter

  @test_list [
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
      "count" => 100,
      "file" => "./test/data/py_code/service.py",
      "function" => "create_app(config_name=None)",
      "line" => 0
    }
  ]

  @doc """
  Component test
  """
  test "generate report of least used" do
    assert report_least_used(@test_list) == [      
      %{
        "count" => 0,
        "file" => "./test/data/py_code/routes/route.py",
        "function" => "del_todo(todo_id)",
        "line" => 7
      },
      %{
        "count" => 10,
        "file" => "./test/data/py_code/routes/route.py",
        "function" => "index()",
        "line" => 1
      },
      %{
        "count" => 100,
        "file" => "./test/data/py_code/service.py",
        "function" => "create_app(config_name=None)",
        "line" => 0
      }
    ]

  end
end
