defmodule PhxExampleWeb.HomeLive.ComponentWithCounter do
  use PhxExampleWeb, :live_component

  @impl true
  def mount(socket) do
    {:ok,
     socket
     |> assign(count: 0)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.js_component
        id="live-component-counter"
        name="Counter"
        props={%{count: @count}}
        callbacks={%{increment: "increment"}}
      />
    </div>
    """
  end

  @impl true
  def handle_event("increment", _, socket) do
    {:noreply, socket |> assign(count: socket.assigns.count + 1)}
  end
end
