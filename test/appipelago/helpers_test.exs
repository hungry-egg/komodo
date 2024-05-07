defmodule Appipelago.HelpersTest do
  use ExUnit.Case
  doctest Appipelago.Helpers

  import Appipelago.Helpers

  describe "arguments_path/1" do
    test "it converts a path spec to an array of strings" do
      assert arguments_path("&2.inner[3].name[5]") == "2.inner.3.name.5"
    end

    test "it works with a single part" do
      assert arguments_path("&2") == "2"
    end

    test "it needs the first arg to be of the form &n" do
      assert_raise(RuntimeError, ~r/'&n' for integer n/, fn -> arguments_path("&g") end)
      assert_raise(RuntimeError, ~r/'&n' for integer n/, fn -> arguments_path("2") end)
    end

    test "raises if brackets aren't matching" do
      assert_raise(RuntimeError, ~r/Unable to parse/, fn -> arguments_path("&2.inner[yay") end)
    end

    test "raises if var inside brackets has a dot" do
      assert_raise(RuntimeError, ~r/Unable to parse/, fn -> arguments_path("&2.inner[2.2]") end)
    end

    test "raises if non-standard characters are used" do
      assert_raise(RuntimeError, ~r/Unable to parse/, fn -> arguments_path("&2.%") end)
      assert_raise(RuntimeError, ~r/Unable to parse/, fn -> arguments_path("&2.inner[%]") end)
    end
  end

  describe "normalise_callback_spec" do
    test "it converts a single string to a callback spec" do
      assert normalise_callback_spec("changed") == ["changed"]
    end

    test "it converts a string payload" do
      assert normalise_callback_spec({"changed", "&1.target"}) == ["changed", "1.target"]
    end

    test "it converts an array of strings payload" do
      assert normalise_callback_spec({"changed", ["&1.target", "&2"]}) == [
               "changed",
               ["1.target", "2"]
             ]
    end

    test "it converts a map payload" do
      assert normalise_callback_spec({"changed", %{"a" => "&1.target", "b" => "&2"}}) == [
               "changed",
               %{"a" => "1.target", "b" => "2"}
             ]
    end
  end
end
