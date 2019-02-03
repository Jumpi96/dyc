defmodule Dyc.DycProcessor do

    @moduledoc """
    Handle the processing of the usage and code data.
    """

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
  end