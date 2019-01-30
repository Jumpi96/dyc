defmodule Dyc.CSVProcessor do

  @moduledoc """
  Handle the .CSV input and transform it to a list of maps,
  that is the internal representation for this data in dyc.
  """

  def process_file(path) do
    argv 
    |> parse_args
    |> process
  end
  
end