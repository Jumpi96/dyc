defmodule Dyc.DycProcessor do

    @moduledoc """
    Handle the processing of the usage and code data.
    """
  
    @doc """
    code_path and csv_file are the input file paths received.
  
    Return something.
    """  
    def process_files({code_path, csv_file}) do
      pid = spawn(__MODULE__, :process_concurrently, [self(), {csv_file, code_path}, {}])
      receive do
        {:ok, data} -> data
      end
    end

    def process_concurrently(caller, {csv_file, code_path}, {}) do
      pid_csv_scraper = spawn(Dyc.UsageScraper, :scrap_file, [self(), csv_file, :csv])
      # Here you should define the other process
      receive do
        {pid_csv_scraper, usage_data} -> send caller, {:ok, usage_data}
      end
    end
    def process_concurrently(caller, {_, code_path}, {usage, nil}) do
      receive do
        {sender, data} -> send caller, {usage, data}
      end
    end
    def process_concurrently(caller, {csv_file, _}, {nil, code}) do
      receive do
        {sender, data} -> send caller, {data, code}
      end
    end

  end