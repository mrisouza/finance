defmodule FinanceTest do
  use ExUnit.Case
  doctest Finance

  test "greets the world" do
    assert Finance.hello() == :world
  end
end
