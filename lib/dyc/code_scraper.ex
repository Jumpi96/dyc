defmodule Dyc.CodeScraper do
  @extensions %{python: ".py"}
  @moduledoc """
  Get the functions data from the input code and transform it to
  the internal representation: [
    ok: %{
      "file" => "file.py",
      "function" => "foo()",
      "line" => "10"
    }
  ]
  """
    
  @doc """
  Receives a project path and the language of the code as an atom.
  
  Returns a list of maps as a message to a caller.
  """
  def scrap_code(caller, path, language) do
    result = scrap_folder(path, language)
    send caller, {:code, result}
  end

  @doc """
  Receives a folder path and the language of the code as an atom.
  
  Returns a list of maps with the internal representation.
  """
  def scrap_folder(path, language) do
    path
      |> File.ls |> elem(1)
      |> Enum.map(&"#{path}/#{&1}")
      |> Enum.map(&scrap_path(&1, language))
      |> Enum.reject(&is_nil/1)
      |> List.flatten()
  end

  @doc """
  Receives a path with unknown type path and language as an atom.
  
  Returns a file or folder scrapped depending on the type.
  """
  def scrap_path(path, language) do
    if File.dir?(path) do
      scrap_folder(path, language)
    else
      scrap_file(path, language)
    end
  end

  @doc """
  Receives a file path and the language of the code as an atom.
  
  Returns a list of maps with functions if it was a code file.
  """
  def scrap_file(path, language) do
    if String.ends_with?(path, @extensions[language]) do
      scrap_code_file(path, language)
    end
  end

  @doc """
  Receives a file path and the language of the code as an atom.
  Uses Stream to read the file, filter the functions and maps its information.

  Returns a list of maps with functions.
  """
  def scrap_code_file(path, :python) do
    path
      |> File.stream!
      |> Stream.with_index
      |> Stream.filter(fn ({line, _index}) -> String.contains?(line, "def ") end) 
      |> Stream.map(fn ({line, index}) -> 
        %{
          "file" => path, 
          "line" => index, 
          "function" => String.slice(line, index_of(line, "def") + 4..index_of(line, ")"))
        } end)
      |> Enum.to_list
  end

  @doc """
  Wrapper to get the index of a char/string inside another string.
  """
  def index_of(string, char), do: string |> :binary.match(char) |> elem(0)
end