defmodule Komodo.ComponentsTest do
  use ExUnit.Case
  doctest Komodo.Components

  import Phoenix.LiveViewTest

  import Komodo.Components

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
               "onAnotherEvent" => ["another_event", "&1.detail[0]"],
               "onYetAnotherEvent" => ["yet_another_event", %{"a" => "&1.detail[0]"}]
             }
    end

    test "it allows using a span as the container" do
      assert {"span", attrs} =
               render_js_component(
                 id: "my-component",
                 name: "MyComponent",
                 tag_name: :span
               )

      assert %{
               "id" => "my-component",
               "data-name" => "MyComponent",
               "data-props" => "{}",
               "data-callbacks" => "{}",
               "phx-hook" => "komodo",
               "phx-update" => "ignore"
             } = attrs
    end

    test "it allows styling the container" do
      assert {_, %{"class" => "some-class", "style" => "some: style;"}} =
               render_js_component(
                 id: "my-component",
                 name: "MyComponent",
                 class: "some-class",
                 style: "some: style;"
               )
    end

    test "sanity check that it produces valid html" do
      html =
        render_component(&js_component/1, %{
          id: "id",
          name: "name",
          props: %{a: 1}
        })

      assert html =~ ~r(data-props="{&quot;a&quot;:1}")
      assert html =~ ~r(data-callbacks="{}")
    end
  end

  describe "arg" do
    test "it converts into an arg structure that the Javascript side will recognise" do
      assert arg(1) == %{__arg__: 1, path: []}
    end

    test "it includes a path if given" do
      assert arg(2, [:how, "are", :you, 4]) == %{__arg__: 2, path: [:how, "are", :you, 4]}
    end

    test "it defaults to the first arg" do
      assert arg() == %{__arg__: 1, path: []}
    end
  end
end
