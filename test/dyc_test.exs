defmodule DycTest do
  use ExUnit.Case
  doctest Dyc

  test "greets the world" do
    assert Dyc.hello() == :world
  end
end
