defmodule DycTest do
  use ExUnit.Case
  doctest Dyc

  test "add 1 + 1" do
    assert Dyc.add(1, 1) == 2
  end
end
