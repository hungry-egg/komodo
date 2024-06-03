defmodule Komodo.Macros do
  defmacro defjsapp(name) do
    quote do
      def unquote(name)(assigns) do
        Komodo.Components.js_app_alt_interface(Map.merge(assigns, %{__name__: unquote(name)}))
      end
    end
  end
end
