defmodule Dyc.CLI do

  @default_count 4

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating the reports
  """

  def run(argv) do
    argv 
    |> parse_args
  end

  @doc """
  `argv` can be -h or --help, which returns   `:help`.

  Otherwise it is a path and a .csv file.

  Return a tuple of `{ code_path, csv_file }`, or :help if help was given.
  """
  def parse_args(argv) do
    parse = OptionParser.parse(argv, switches: [help: :boolean],
                                     aliases:  [h:    :help])
    case parse do
      {[help: true], _,          _} -> :help
      {_, [code_path, csv_file], _} -> {code_path, csv_file}
      _                                 -> :help
    end
  end

  def process(:help) do
    IO.puts """
    usage:  dyc <code_path> <csv_file> [ count | #{@default_count} ]
    """
    System.halt(0)
  end
end