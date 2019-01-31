defmodule Dyc.DycProcessor do

    @moduledoc """
    Handle the processing of the usage and code data.
    """
  
    @doc """
    code_path and csv_file are the input file paths received.
  
    Return something.
    """  
    def process_files({_code_path, csv_file}) do
      csv_file
        |> Dyc.UsageScraper.scrap_file(:csv, csv_file)
    end
  end