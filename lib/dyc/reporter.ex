defmodule Dyc.Reporter do

    @moduledoc """
    Handle the reporting of the metrics.
    """

    @doc """
    
    """
    def report_least_used(list) do
      list 
        |> Enum.sort_by(&Map.fetch(&1, "count"))
    end
  end