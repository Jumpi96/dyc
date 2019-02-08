defmodule Dyc.CLI do

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating the reports
  """

  @page_size Application.get_env(:dyc, :page_size)
  @current_reports ["A", "B"]
  @columns ["function", "file", "line", "count"]

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
  reports for them to select. It iterates while you do not enter "Q".
  """
  def choose_report(:exit), do: IO.puts "Bye!"
  def choose_report(data) do
    IO.puts """
    Choose a report to print:
    A) Least used functions in your project.
    B) Most used functions in your project.
    Q) Exit dyc.
    """
    IO.gets("> ")
      |> String.trim
      |> String.capitalize
      |> process_report(data, 0)
    choose_report(data)
  end

  @doc """
  Let user navigate the report, choose another report or exit the application.
  """
  def process_report("Q", _data, _offset), do: System.halt
  def process_report(report, data, offset) when report in @current_reports do
    print_report(report, data, offset)
    page_navigate(report, data, offset)
  end
  def process_report(_report, data, _offset), do: choose_report(data)

  @doc """
  Use Reporter and TableFormatter to show the report
  with a determinated offset.
  """
  def print_report(report, data, offset) do
    report
      |> Dyc.Reporter.get_report(data, offset)
      |> Dyc.TableFormatter.print_table_for_columns(@columns)
  end

  @doc """
  Receive a navigation input and continue the CLI flow.
  """
  def page_navigate(report, data, offset) do
    IO.puts "\nA) Next page. B) Previous page. Q) Exit report."
    input = "> "
      |> IO.gets
      |> String.trim
      |> String.capitalize
    case input do
      "A" -> process_report(report, data, sanitize_offset(data, offset + @page_size, @page_size))
      "B" -> process_report(report, data, sanitize_offset(data, offset - @page_size, @page_size))
      "Q" -> IO.puts "\n"
      _ -> offset
    end
  end

  @doc """
  Avoid an offset off the data.
  """
  def sanitize_offset(data, offset, page_size) do
    cond do
      offset >= Enum.count(data) -> offset - page_size
      offset < 0 -> offset + page_size
      true -> offset
    end
  end

end
