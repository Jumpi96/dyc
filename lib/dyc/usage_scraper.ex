defmodule Dyc.UsageScraper do

  @moduledoc """
  Get the usage data from the input file and transform it to
  the internal representation: [
    ok: %{
      "count" => "1",
      "file" => "file.py",
      "function" => "foo()",
      "line" => "10"
    }
  ]
  """
    
  @doc """
  Receives a file path and the format of the file.
  
  Returns a checked list of maps.
  """
  def scrap_file(path, format) do
    File.stream!(path) 
      |> decode_file(format)
      |> decode_result
  end

  @doc """
  Receives a stream from a .csv file.
  
  Returns a list of maps.
  """
  def decode_file(file_stream, :csv) do
    file_stream
      |> CSV.decode!(headers: true) 
      |> Enum.to_list
      |> Keyword.values
  end

  @doc """
  Checks if the maps contains the keys needed.
  
  Returns a checked list of maps.
  """
  def check_maps(usage_list) do
    required_keys = ["count", "file", "function", "line"]
    result = usage_list |> Enum.map(
      fn map -> Enum.all?(required_keys, &Map.has_key?(map, &1)) end
    )
    if Enum.find(check_maps(result), fn x -> x = false end) == nil do
      {:ok, usage_list}
    else
      {:error, usage_list}
    end
  end

  def decode_result({:ok, usage_list}), do: usage_list
  def decode_result({:error, _usage_list}) do
    IO.puts """
    Error: .CSV file is not valid.
    """
    System.halt(1)
  end
end