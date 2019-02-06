defmodule Dyc.Reporter do
  @moduledoc """
  Handle the reporting of the metrics.
  """

  @doc """
  Get the selected report from the CLI.
  Returns the report as a list.
  """
  def get_report("A", data), do: report_least_used(data)

  def report_least_used(list) do
    IO.puts "dyc - Report: Least used functions in the code. \n"
    list 
      |> Enum.sort_by(&Map.fetch(&1, "count"))
  end
end