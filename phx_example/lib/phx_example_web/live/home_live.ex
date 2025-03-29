defmodule PhxExampleWeb.HomeLive do
  use PhxExampleWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(marker: random_marker(), count: 0)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-3">
      <h1 class="font-bold text-xl">LiveView page rendering multiple frontend apps</h1>
      <section>
        <p class="font-semibold mb-2 flex space-x-4 items-center">
          <span>
            LiveView state: <span class="inline-flex w-32">(x: <%= Enum.at(@marker,0) %>, y: <%= Enum.at(@marker, 1) %>)</span>
          </span>
          <button phx-click="update_marker" class="p-2 bg-slate-300 rounded">
            Push new coordinate from liveview
          </button>
        </p>
      </section>
      <div class="grid grid-cols-2 gap-y-4">
        <section>
          <h2 class="font-semibold mb-2">Custom element component</h2>
          <.js_component
            id="custom-element-map"
            name="CustomElementMap"
            props={%{marker: @marker}}
            callbacks={%{"select-coord": {"selected_coord", [arg(1, [:detail, :x]), arg(1, [:detail, :y])]}}}
          />
        </section>
        <section>
          <h2 class="font-semibold mb-2">React component</h2>
          <.js_component
            id="react-map"
            name="ReactMap"
            props={%{marker: @marker}}
            callbacks={%{onSelectCoord: {"selected_coord", [arg(1, [:x]), arg(1, [:y])]}}}
          />
        </section>
        <section>
          <h2 class="font-semibold mb-2">Vue component</h2>
          <.js_component
            id="vue-map"
            name="VueMap"
            props={%{marker: @marker}}
            callbacks={%{selectCoord: {"selected_coord", [arg(1), arg(2)]}}}
          />
        </section>
        <section>
          <h2 class="font-semibold mb-2">Svelte component</h2>
          <.js_component
            id="svelte-map"
            name="SvelteMap"
            props={%{marker: @marker}}
            callbacks={%{onSelectCoord: {"selected_coord", arg(1)}}}
          />
        </section>
      </div>
      <div class="grid grid-cols-2 gap-y-4">
        <div>
          <h2 class="font-semibold mb-2">Counter from LiveView</h2>
          <.js_component
            id="live-view-counter"
            name="Counter"
            props={%{count: @count}}
            callbacks={%{increment: "increment"}}
          />
        </div>
        <div>
          <h2 class="font-semibold mb-2">Counter internal to LiveComponent</h2>
          <.live_component
            id="component-with-counter"
            module={PhxExampleWeb.HomeLive.ComponentWithCounter}
          />
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("selected_coord", marker, socket) do
    {:noreply, socket |> assign(marker: marker)}
  end

  @impl true
  def handle_event("update_marker", _, socket) do
    {:noreply, socket |> assign(marker: random_marker())}
  end

  @impl true
  def handle_event("increment", _, socket) do
    {:noreply, socket |> assign(count: socket.assigns.count + 1)}
  end

  defp random_marker do
    rand = fn -> Enum.random(0..100) end
    [rand.(), rand.()]
  end
end
