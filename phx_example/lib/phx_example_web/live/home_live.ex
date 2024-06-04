defmodule PhxExampleWeb.HomeLive do
  use PhxExampleWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(marker: random_marker())}
  end

  def render(assigns) do
    ~H"""
    <div class="flex flex-col gap-y-3">
      <h1 class="font-bold text-xl">LiveView page rendering multiple frontend apps</h1>
      <div class="grid grid-cols-2 gap-y-4">
        <section>
          <h2 class="font-semibold mb-2">LiveView state (x, y)</h2>
          <div class="flex flex-col gap-3 items-center max-w-48">
            <p>
              <span>(<%= Enum.join(@marker, ", ") %>)</span>
            </p>
            <button phx-click="update_marker" class="p-2 bg-slate-300 rounded">
              Push new coord from liveview
            </button>
          </div>
        </section>
        <section>
          <h2 class="font-semibold mb-2">React component</h2>
          <.js_component
            id="react-map"
            name="ReactMap"
            props={%{marker: @marker}}
            callbacks={%{onSelectCoord: {"selected_coord", ["&1.x", "&1.y"]}}}
          />
        </section>
        <section>
          <h2 class="font-semibold mb-2">Vue component</h2>
          <.js_component
            id="vue-map"
            name="VueMap"
            props={%{marker: @marker}}
            callbacks={%{selectCoord: {"selected_coord", ["&1", "&2"]}}}
          />
        </section>
        <section>
          <h2 class="font-semibold mb-2">Svelte component</h2>
          <.js_component
            id="svelte-map"
            name="SvelteMap"
            props={%{marker: @marker}}
            callbacks={%{selectCoord: {"selected_coord", "&1.detail"}}}
          />
        </section>
      </div>
    </div>
    """
  end

  def handle_event("selected_coord", marker, socket) do
    {:noreply, socket |> assign(marker: marker)}
  end

  def handle_event("update_marker", _, socket) do
    {:noreply, socket |> assign(marker: random_marker())}
  end

  defp random_marker do
    rand = fn -> Enum.random(0..100) end
    [rand.(), rand.()]
  end
end
