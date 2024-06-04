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

  defp generate_id(prefix) do
    "#{prefix}-#{System.unique_integer([:positive]) |> Integer.to_string(36)}"
  end
end
