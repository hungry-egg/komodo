defmodule Komodo.ComponentsTest do
  use ExUnit.Case
  doctest Komodo.Components

  import Phoenix.LiveViewTest

  import Komodo.Components, only: [js_component: 1]

  describe "js_component/1" do
    defp render_js_component(args) when is_list(args) do
      html = render_component(&js_component/1, args)
      [{tag_name, attrs, _}] = Floki.parse_document!(html)
      {tag_name, Enum.into(attrs, %{})}
    end

    test "it renders an empty div (non self-closing)" do
      html = render_component(&js_component/1, id: "my-component", name: "MyComponent")
      assert html =~ ~r(^<div[^>]*></div>$)
    end

    test "it renders the correct attrs" do
      {_, attrs} = render_js_component(id: "my-component", name: "MyComponent")

      assert %{
               "id" => "my-component",
               "data-name" => "MyComponent",
               "data-props" => "{}",
               "data-callbacks" => "{}",
               "phx-hook" => "komodo",
               "phx-update" => "ignore"
             } = attrs
    end

    test "json stringifies props" do
      {_, %{"data-props" => data_props}} =
        render_js_component(
          id: "my-component",
          name: "MyComponent",
          props: %{list: [1, 2, 3], map: %{a: 1, b: 2}, string: "yay"}
        )

      assert Jason.decode!(data_props) == %{
               "list" => [1, 2, 3],
               "map" => %{"a" => 1, "b" => 2},
               "string" => "yay"
             }
    end

    test "json stringifies callbacks, complete with payload spec" do
      {_, %{"data-callbacks" => data_callbacks}} =
        render_js_component(
          id: "my-component",
          name: "MyComponent",
          callbacks: %{
            onEvent: "event",
            onAnotherEvent: {"another_event", "&1.detail[0]"},
            onYetAnotherEvent: {"yet_another_event", %{"a" => "&1.detail[0]"}}
          }
        )

      assert Jason.decode!(data_callbacks) == %{
               "onEvent" => ["event"],
               "onAnotherEvent" => ["another_event", "0.detail.0"],
               "onYetAnotherEvent" => ["yet_another_event", %{"a" => "0.detail.0"}]
             }
    end

    test "it allows changing the element tag name" do
      assert {"section", _} =
               render_js_component(
                 id: "my-component",
                 name: "MyComponent",
                 tag_name: "section"
               )
    end

    test "it allows adding extra attributes" do
      assert {_, %{"class" => "some-class"}} =
               render_js_component(
                 id: "my-component",
                 name: "MyComponent",
                 class: "some-class"
               )
    end
  end
end
