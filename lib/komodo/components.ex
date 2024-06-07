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

  attr(:tag_name, :atom, default: :div, values: [:div, :span])
  attr(:id, :string, required: true)
  attr(:name, :string, required: true)
  attr(:props, :map, default: %{})
  attr(:callbacks, :map, default: %{})
  attr(:class, :string, default: "")
  attr(:style, :string, default: "")

  def js_component(assigns) do
    json_lib = Phoenix.json_library()

    assigns =
      assigns
      |> assign(
        data_props: assigns.props |> json_lib.encode!(),
        data_callbacks:
          assigns.callbacks
          |> map_values(&Helpers.normalise_callback_spec/1)
          |> json_lib.encode!()
      )
      # this avoids unnecessary updates being sent - in any case the callback spec
      # is only used on mount in javascript so any subsequent updates would be ignored anyway
      |> mark_as_unchanged([:data_callbacks])

    # This is more efficient in terms of diffs than using dynamic_tag
    ~H"""
    <%= {:safe, [?<, Atom.to_string(@tag_name)]} %>
      phx-hook="komodo"
      phx-update="ignore"
      data-name="<%= @name %>"
      id="<%= @id %>"
      class="<%= @class %>"
      style="<%= @style %>"
      data-props="<%= @data_props %>"
      data-callbacks="<%= @data_callbacks %>"
    <%= {:safe, [?>]} %><%= {:safe, [?<, ?/, Atom.to_string(@tag_name), ?>]} %>
    """
  end

  # Remove the specified from keys from the assigns __changed__  object.
  # This tells heex no updates are to be sent down the wire for these assigns
  defp mark_as_unchanged(assigns = %{__changed__: changed = %{}}, keys) when is_list(keys) do
    %{assigns | __changed__: Map.drop(changed, keys)}
  end

  defp mark_as_unchanged(assigns = %{__changed__: nil}, keys) when is_list(keys), do: assigns

  defp map_values(map, func) when is_map(map) and is_function(func) do
    Enum.map(map, fn {k, v} -> {k, func.(v)} end)
    |> Enum.into(%{})
  end
end
