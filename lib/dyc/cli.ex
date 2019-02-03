defmodule Dyc.CLI do

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating the reports
  """

  def run(argv) do
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

  Return something, or a message if the input wasn't valid.
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
    Dyc.DycProcessor.process_files(files, {})
  end
end
