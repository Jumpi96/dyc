defmodule Dyc.DycProcessor do

    @moduledoc """
    Handle the processing of the usage and code data.
    """
  
    @doc """
    code_path and csv_file are the input file paths received.
  
    Return something.
    """  
    def process_files({code_path, csv_file}) do
      spawn(__MODULE__, :process_concurrently, [self(), {csv_file, code_path}, {}])
      receive do
        {usage_data, code_data} -> usage_data
      end
    end

    def process_concurrently(caller, {csv_file, code_path}, {}) do
      spawn(Dyc.UsageScraper, :scrap_file, [self(), csv_file, :csv])
      spawn(Dyc.CodeScraper, :scrap_code, [self(), code_path, :python])
      receive do
        {:usage, usage_data} -> process_concurrently(caller, {usage_data, nil})
        {:code, code_data} -> process_concurrently(caller, {nil, code_data})
      end
    end
    def process_concurrently(caller, {usage, nil}) do
      receive do
        {_, code_data} -> send caller, {usage, code_data}
      end
    end
    def process_concurrently(caller, {nil, code}) do
      receive do
        {_, usage_data} -> send caller, {usage_data, code}
      end
    end

  end