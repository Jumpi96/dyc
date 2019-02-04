defmodule Dyc.DycProcessor do

    @moduledoc """
    Handle the processing of the usage and code data.
    """

    def process(files) do
      files 
        |> process_files({})
        |> merge_lists
    end

    @doc """
    Process two files concurrently. Waits for data returned by each
    process and send a message to caller function.
  
    Return tuple of list of maps.
    """ 
    def process_files({csv_file, code_path}, {}) do
      spawn(Dyc.UsageScraper, :scrap_file, [self(), csv_file, :csv])
      spawn(Dyc.CodeScraper, :scrap_code, [self(), code_path, :python])
      receive do
        {:usage, usage_data} -> process_files({csv_file, code_path}, {usage_data, nil})
        {:code, code_data} -> process_files({csv_file, code_path}, {nil, code_data})
      end
    end
    def process_files(_, {usage, nil}) do
      receive do
        {_, code_data} -> {usage, code_data}
      end
    end
    def process_files(_, {nil, code}) do
      receive do
        {_, usage_data} -> {usage_data, code}
      end
    end

    @doc """
    Merge two files processed results.
  
    Return list of functions of the project with usage summarized.
    """ 
    def merge_lists({usage_list, code_list}) do
      code_list
        |> Enum.map(&(
          usage_list
            |> Enum.filter(fn x -> x["function"] == &1["function"] end)
            |> sum_function_usage(&1)
        ))
    end

    @doc """
    Receives list of usages of the functions and map of the function.
  
    Return map of the function with new key "count".
    """ 
    def sum_function_usage(usage_list, function) do
      sum = usage_list 
        |> Enum.reduce(0,
          fn x, acc -> 
            x["count"]
              |> Integer.parse 
              |> elem(0)
              |> Kernel.+(acc)
          end)
      Map.put(function, "count", sum)
    end
  end