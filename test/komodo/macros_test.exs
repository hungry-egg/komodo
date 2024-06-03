defmodule Komodo.MacrosTest do
  use ExUnit.Case
  import Phoenix.LiveViewTest

  require Komodo.Macros
  import Komodo.Macros, only: [defjsapp: 1]

  defjsapp(:my_app)

  describe "defjsapp macro" do
    test "it creates a component with the appropriate name" do
      html =
        render_component(&my_app/1, %{
          prop: "value",
          "@callback": "handler"
        })

      [{_, attrs, _}] = Floki.parse_document!(html)
      attrs = attrs |> Enum.into(%{})

      assert %{
               "data-name" => "my_app",
               "data-props" => data_props,
               "data-callbacks" => data_callbacks
             } = attrs

      assert data_props == Jason.encode!(%{prop: "value"})
      assert data_callbacks == Jason.encode!(%{callback: ["handler"]})
    end
  end
end
