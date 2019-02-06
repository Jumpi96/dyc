defmodule Dyc.CLI do

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating the reports
  """

  @current_reports ["A", "B"]

  def main(argv) do
    argv 
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns   `:help`.

  Otherwise it is a path and a .csv file.

  Return a tuple of `{code_path, csv_file}`, or :help if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases:  [h:    :help])
    case parse do
      {[help: true], _,          _} -> :help
      {_, [code_path, csv_file], _} -> check_args({code_path, csv_file})
      _                             -> :help
    end
  end

  @doc """
  Check if code_path is an existing path and csv_file an existing file.

  Return a tuple of `{code_path, csv_file}`, or :error if any does not exist.
  """
  def check_args({code_path, csv_file}) do
    case {File.exists?(code_path), File.open(csv_file)} do
      {true, {:ok, _}} -> {code_path, csv_file}
      _                -> :error
    end
  end

  @doc """
  Receive an atom or a tuple with both files for returning a mesage or calling
  the processing of the files.
  """
  def process(:error) do
    IO.puts """
    Error: input arguments are not valid.
    """
  end

  def process(:help) do
    IO.puts """
    Usage: dyc <code_path> <csv_file>
    """
  end

  def process(files) do
    IO.puts "\nWelcome to dyc!\n"
    files
      |> Dyc.DycProcessor.process
      |> choose_report
  end

  @doc """
  Receive an atom or the processed data to show the user the available
  reports for them to select. It iterates while you do not enter "0".
  """
  def choose_report(:exit), do: IO.puts "Bye!"
  def choose_report(data) do
    IO.puts """
    Choose a report to print:
    A) Least used functions in your project.
    B) Most used functions in your project.
    0) Exit dyc.
    """
    IO.gets("> ")
      |> String.trim
      |> String.capitalize
      |> print_report(data)
    choose_report(data)
  end

  @doc """
  Calls Reporter to get the selected report. If it receives a "0",
  it exits the application.
  """
  def print_report("0", _data), do: System.halt
  def print_report(report, data) when report in @current_reports do
    columns = ["function", "file", "line", "count"]
    report
      |> Dyc.Reporter.get_report(data)
      |> Dyc.TableFormatter.print_table_for_columns(columns)
  end
  def print_report(_report, data), do: choose_report(data)
end
