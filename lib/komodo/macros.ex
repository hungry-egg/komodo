defmodule Komodo.Macros do
  defmacro defjscomponent(name) do
    quote do
      def unquote(name)(assigns) do
        Komodo.Components.js_component_alt_interface(
          Map.merge(assigns, %{__name__: unquote(name)})
        )
      end
    end
  end
end
