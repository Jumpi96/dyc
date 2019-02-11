defmodule Dyc.Reporter do
  @moduledoc """
  Handle the reporting of the metrics.
  """
  @page_size Application.get_env(:dyc, :page_size)
  @functions_columns ["function", "file", "line", "count"]
  @file_columns ["file", "count"]

  @doc """
  Get the selected report from the CLI.
  Returns the report as a list.
  """
  def get_report(report, data, offset) do
    case report do
      "A" -> data |> report_least_used |> paginate(offset, @page_size)
      "B" -> data |> report_most_used |> paginate(offset, @page_size)
      "C" -> data |> report_least_used_files |> paginate(offset, @page_size)
      "D" -> data |> report_most_used_files |> paginate(offset, @page_size)
      "E" -> data |> report_biggest_abs_dev_files |> paginate(offset, @page_size)
    end
  end

  def paginate(report, offset, page_size) do
    {report |> elem(0) |> Enum.slice(offset, page_size), elem(report, 1)}
  end

  def report_least_used(list) do
    IO.puts "dyc - Report: Least used functions in the project. \n"
    report = list 
      |> Enum.sort_by(&Map.fetch(&1, "count"))
    {report, @functions_columns}
  end

  def report_most_used(list) do
    IO.puts "dyc - Report: Most used functions in the project. \n"
    report = list 
      |> Enum.sort_by(&Map.fetch(&1, "count"), &>=/2)
    {report, @functions_columns}
  end

  def report_least_used_files(list) do
    IO.puts "dyc - Report: Least used files in the project. \n"
    report = list
      |> group_by_file
      |> Enum.sort_by(&Map.fetch(&1, "count"))
    {report, @file_columns}
  end

  def report_most_used_files(list) do
    IO.puts "dyc - Report: Most used files in the project. \n"
    report = list 
      |> group_by_file
      |> Enum.sort_by(&Map.fetch(&1, "count"), &>=/2)
    {report, @file_columns}
  end

  def report_biggest_abs_dev_files(list) do
    IO.puts """
      dyc - Report: Biggest absolute deviation between files in the project. \n
    """
    report = list
      |> group_by_file
      |> calc_abs_dev
      |> Enum.sort_by(&Map.fetch(&1, "deviation"), &>=/2)
      {report, @file_columns ++ ["deviation"]}
  end

  def calc_abs_dev(files) do
    avg = files
      |> Enum.reduce(0, fn x, acc -> acc + x["count"] end)
      |> Kernel./(Enum.count(files))
    files |> Enum.map(&(Map.put(&1, "deviation", abs(&1["count"] - avg))))
  end


  def group_by_file(list) do
    list 
      |> Enum.group_by(&(&1["file"])) 
      |> Enum.to_list 
      |> Enum.map(
        fn x -> %{
          "file" => elem(x, 0), 
          "count" => Enum.reduce(elem(x, 1), 0, fn x, acc -> acc + x["count"] end)
        } 
      end)
  end
end