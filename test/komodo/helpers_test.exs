defmodule Komodo.HelpersTest do
  use ExUnit.Case
  doctest Komodo.Helpers

  import Komodo.Helpers

  describe "arguments_path/1" do
    test "it converts a path spec to an array of path strings, replacing the root with the given arg num" do
      assert arguments_path("evt.inner[3].name[5]", 3) == "3.inner.3.name.5"
    end

    test "it works with a single part" do
      assert arguments_path("evt", 2) == "2"
    end

    test "raises if brackets aren't matching" do
      assert_raise(RuntimeError, ~r/Unable to parse/, fn -> arguments_path("evt.inner[yay", 0) end)
    end

    test "raises if var inside brackets has a dot" do
      assert_raise(RuntimeError, ~r/Unable to parse/, fn ->
        arguments_path("evt.inner[2.2]", 0)
      end)
    end

    test "raises if non-standard characters are used" do
      assert_raise(RuntimeError, ~r/Unable to parse/, fn -> arguments_path("evt.%", 0) end)
      assert_raise(RuntimeError, ~r/Unable to parse/, fn -> arguments_path("evt.inner[%]", 0) end)
    end
  end

  # describe "normalise_callback_spec" do
  #   test "it converts a single string to a callback spec" do
  #     assert normalise_callback_spec("changed") == ["changed"]
  #   end

  #   test "it converts a string payload" do
  #     assert normalise_callback_spec({"changed", "&1.target"}) == ["changed", "0.target"]
  #   end

  #   test "it converts an array of strings payload" do
  #     assert normalise_callback_spec({"changed", ["&1.target", "&2"]}) == [
  #              "changed",
  #              ["0.target", "1"]
  #            ]
  #   end

  #   test "it converts a map payload" do
  #     assert normalise_callback_spec({"changed", %{"a" => "&1.target", "b" => "&2"}}) == [
  #              "changed",
  #              %{"a" => "0.target", "b" => "1"}
  #            ]
  #   end
  # end

  describe "maybe_replace_code_with_path_string" do
    test "it replaces code with a path string for a given arg num" do
      assert maybe_replace_code_with_path_string("markers[3].x", ["eggs", "markers"]) == "1.3.x"
    end

    test "returns nil if it can't find that arg name" do
      assert maybe_replace_code_with_path_string("markers[3].x", ["eggs"]) == nil
    end

    test "returns nil if it doesn't look like a path string" do
      assert maybe_replace_code_with_path_string(~s("a string"), ["eggs", "markers"]) == nil
    end
  end
end
