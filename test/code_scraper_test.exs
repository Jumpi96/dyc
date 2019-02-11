defmodule CodeScraperTest do
    use ExUnit.Case
  
    import Dyc.CodeScraper
  
    @test_map [
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
        "file" => "./test/data/py_code/utils/cache.py",
        "function" => "clean_cache()",
        "line" => 0
      },
      %{
        "file" => "./test/data/py_code/service.py", 
        "function" => "create_app(config_name=None)", 
        "line" => 0
      }
    ]
    @test_project "./test/data/py_code"
    @test_file "./test/data/py_code/service.py"
  
    @doc """
    Component test
    """
    test "scrap project concurrently" do
      scrap_code(self(), @test_project, :python)
      receive do
        {_pid, data} -> assert Enum.sort(data) == Enum.sort(@test_map)
        after 2000 -> assert 0 == @test_map
      end
    end
  
    @doc """
    Unit tests
    """
    test "scrap .py code file" do
      assert scrap_code_file(@test_file, :python) ==
        [
          %{
            "file" => "./test/data/py_code/service.py", 
            "function" => "create_app(config_name=None)", 
            "line" => 0
          }
        ]
    end

    test "index of char in string" do
      assert index_of("def function():", "def") == 0
      assert index_of("def function():", ")") == 13
    end
  end