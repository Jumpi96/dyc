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
  @functions_columns ["function", "file", "line", "count"]
  @file_columns ["file", "count"]

  @doc """
  Component tests
  """
  test "generate report of least used" do
    assert get_report("A", @test_list, 0) == {[      
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
    ], @functions_columns}
  end

  test "generate report of most used" do
    assert get_report("B", @test_list, 0) == {[      
      %{
        "count" => 100,
        "file" => "./test/data/py_code/service.py",
        "function" => "create_app(config_name=None)",
        "line" => 0
      },
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
      }
    ], @functions_columns}
  end

  test "generate report of least used files" do
    assert get_report("C", @test_list, 0) == {[      
      %{"count" => 10, "file" => "./test/data/py_code/routes/route.py"},
      %{"count" => 100, "file" => "./test/data/py_code/service.py"}
    ], @file_columns}
  end

  test "generate report of most used files" do
    assert get_report("D", @test_list, 0) == {[
      %{"count" => 100, "file" => "./test/data/py_code/service.py"},
      %{"count" => 10, "file" => "./test/data/py_code/routes/route.py"}
    ], @file_columns}
  end

  @doc """
  Unit tests
  """
  test "generate report with an offset" do
    report = @test_list 
      |> report_most_used
    assert paginate(report, 1, 1) ==
      {[
        %{
          "count" => 10,
          "file" => "./test/data/py_code/routes/route.py",
          "function" => "index()",
          "line" => 1
        }
      ], elem(report, 1)}
  end

end
