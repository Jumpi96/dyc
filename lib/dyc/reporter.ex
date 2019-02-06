defmodule Dyc.Reporter do
  @moduledoc """
  Handle the reporting of the metrics.
  """

  @doc """
  Get the selected report from the CLI.
  Returns the report as a list.
  """
  def get_report(report, data) do
    case report do 
      "A" -> report_least_used(data)
      "B" -> report_most_used(data)
    end
  end

  def report_least_used(list) do
    IO.puts "dyc - Report: Least used functions in the project. \n"
    list 
      |> Enum.sort_by(&Map.fetch(&1, "count"))
  end

  def report_most_used(list) do
    IO.puts "dyc - Report: Most used functions in the project. \n"
    list 
      |> Enum.sort_by(&Map.fetch(&1, "count"), &>=/2)
  end
end