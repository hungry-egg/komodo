defmodule Komodo.ComponentsTest do
  use ExUnit.Case
  doctest Komodo.Components

  import Phoenix.LiveViewTest

  import Komodo.Components, only: [js_app: 1, js_app_alt_interface: 1]

  describe "js_app/1" do
    defp render_js_app(args) when is_list(args) do
      html = render_component(&js_app/1, args)
      [{tag_name, attrs, _}] = Floki.parse_document!(html)
      {tag_name, Enum.into(attrs, %{})}
    end

    test "it renders an empty div (non self-closing)" do
      html = render_component(&js_app/1, name: "MyApp")
      assert html =~ ~r(^<div[^>]*></div>$)
    end

    test "it renders the correct attrs" do
      {_, attrs} = render_js_app(name: "MyApp")

      assert %{
               "data-name" => "MyApp",
               "data-props" => "{}",
               "data-callbacks" => "{}",
               "phx-hook" => "komodo",
               "phx-update" => "ignore"
             } = attrs
    end

    test "json stringifies props" do
      {_, %{"data-props" => data_props}} =
        render_js_app(
          name: "MyApp",
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
        render_js_app(
          name: "MyApp",
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

    test "it gives a default id" do
      assert {_, %{"id" => id}} = render_js_app(name: "MyApp")
      assert id =~ ~r(^MyApp-\w+$)
    end

    test "it allows setting the id" do
      assert {_, %{"id" => "my-id"}} = render_js_app(name: "MyApp", id: "my-id")
    end

    test "it allows changing the element tag name" do
      assert {"section", _} =
               render_js_app(
                 name: "MyApp",
                 tag_name: "section"
               )
    end

    test "it allows adding extra attributes" do
      assert {_, %{"class" => "some-class"}} =
               render_js_app(
                 name: "MyApp",
                 class: "some-class"
               )
    end
  end

  describe "js_app_alt_interface" do
    defp render_js_app_alt_interface(args) when is_list(args) do
      html = render_component(&js_app_alt_interface/1, args)
      [{tag_name, attrs, _}] = Floki.parse_document!(html)
      {tag_name, Enum.into(attrs, %{})}
    end

    test "it splits props and callbacks using @ prefix" do
      {_, attrs} =
        render_js_app_alt_interface(
          __name__: "MyApp",
          prop1: %{some: "value"},
          prop2: ["another", "value"],
          "@callback1": "handler1",
          "@callback2": {"handler2", "&1"}
        )

      assert %{
               "data-name" => "MyApp",
               "data-props" => data_props,
               "data-callbacks" => data_callbacks,
               "phx-hook" => "komodo",
               "phx-update" => "ignore"
             } = attrs

      assert Jason.decode!(data_props) == %{
               "prop1" => %{"some" => "value"},
               "prop2" => ["another", "value"]
             }

      assert Jason.decode!(data_callbacks) == %{
               "callback1" => ["handler1"],
               "callback2" => ["handler2", "0"]
             }
    end
  end
end
