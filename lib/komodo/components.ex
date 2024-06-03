defmodule Komodo.Components do
  use Phoenix.Component

  alias Komodo.Helpers

  @doc """
  Function component for rendering javascript components

  It uses a "props-in, callbacks-out" data-flow, so for example a React component that is used in React like so:

  ```js
  <MyComponent count={43} onIncrement={() => handleIncrement()} />
  ```

  would be rendered from a live view as
  ```heex
  <.js_component name="MyComponent" props={%{count: 43}} callbacks={%{onIncrement: "increment"}} />
  ```
  where `"increment"` is the event name sent back to the live view.
  """

  attr(:id, :string)
  attr(:name, :string, required: true)
  attr(:props, :map, default: %{})
  attr(:callbacks, :map, default: %{})
  attr(:tag_name, :string, default: "div")
  attr(:rest, :global)

  def js_component(assigns) do
    json_lib = Phoenix.json_library()
    data_props = json_lib.encode!(assigns.props)

    data_callbacks =
      json_lib.encode!(
        assigns.callbacks
        |> Enum.map(fn {k, v} -> {k, Helpers.normalise_callback_spec(v)} end)
        |> Enum.into(%{})
      )

    assigns = assigns |> assign(data_props: data_props, data_callbacks: data_callbacks)

    ~H"""
    <.dynamic_tag
      name={@tag_name}
      id={assigns[:id] || generate_id(@name)}
      phx-hook="komodo"
      phx-update="ignore"
      data-name={@name}
      data-props={@data_props}
      data-callbacks={@data_callbacks}
      {@rest}
    ></.dynamic_tag>
    """
  end

  @doc """
  Not to be used directly - this is used by the defjscomponent macro

  ```heex
  <.js_component_alt_interface __name__="MyComponent" prop1={3} @changed="handle_changed" />
  ```

  is equivalent to

  ```heex
  <.js_component name="MyComponent" props={%{prop1: 3}} callbacks={%{changed: "handle_changed"}} />
  ```
  """
  def js_component_alt_interface(assigns = %{__name__: name}) do
    {callbacks, props} =
      assigns
      |> assigns_to_attributes()
      |> Keyword.delete(:__name__)
      |> Enum.split_with(fn {key, _} -> key |> Atom.to_string() |> String.starts_with?("@") end)

    assigns =
      assign(assigns,
        name: name,
        props: props |> Enum.into(%{}),
        callbacks:
          callbacks
          |> Enum.map(fn {k, v} -> {k |> Atom.to_string() |> String.trim_leading("@"), v} end)
          |> Enum.into(%{})
      )

    ~H"""
    <.js_component name={@name} props={@props} callbacks={@callbacks} />
    """
  end

  defp generate_id(prefix) do
    "#{prefix}-#{System.unique_integer([:positive]) |> Integer.to_string(36)}"
  end
end
