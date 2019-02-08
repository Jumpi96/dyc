defmodule Dyc.Reporter do
  @moduledoc """
  Handle the reporting of the metrics.
  """
  @page_size Application.get_env(:dyc, :page_size)

  @doc """
  Get the selected report from the CLI.
  Returns the report as a list.
  """
  def get_report(report, data, offset) do
    case report do
      "A" -> data |> report_least_used |> paginate(offset, @page_size)
      "B" -> data |> report_most_used |> paginate(offset, @page_size)
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

  def paginate(report, offset, page_size) do
    report |> Enum.slice(offset, page_size)
  end
end