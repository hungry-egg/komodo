defmodule Komodo.MacrosTest do
  use ExUnit.Case
  alias Komodo.Macros

  doctest Macros

  require Macros

  describe "normalise_param_spec" do
    test "it allows passing a json stringifiable thing" do
      assert Macros.normalise_param_spec(4) == [4, nil]
      assert Macros.normalise_param_spec("word") == ["word", nil]
      assert Macros.normalise_param_spec([1, 2]) == [[1, 2], nil]
      assert Macros.normalise_param_spec(%{a: 1}) == [%{a: 1}, nil]
    end

    test "it allows mixing with the yielded arg" do
      assert Macros.normalise_param_spec(fn evt -> %{a: evt.some.path[3], b: 4} end) == [
               %{b: 4},
               %{a: "0.some.path.3"}
             ]
    end

    test "it works with string keys" do
      assert Macros.normalise_param_spec(fn evt -> %{"a" => evt.clientX, "b" => 4} end) == [
               %{"b" => 4},
               %{"a" => "0.clientX"}
             ]
    end

    test "allows yielding just the event path" do
      assert Macros.normalise_param_spec(fn evt -> evt.clientX end) == [nil, "0.clientX"]
    end

    test "allows yielding something else (not that you'd use this)" do
      a = 4
      assert Macros.normalise_param_spec(fn _ -> a end) == [4, nil]
    end
  end
end
