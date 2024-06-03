# Svelte bindings for Komodo Elixir library

## Pre-installation

To write Svelte components, you'll need to work with the Svelte compiler somehow - this library does not cover that.

However, with the standard Phoenix ESBuild setup, it's easily done by:

1. Following [the instructions in the Phoenix docs](https://hexdocs.pm/phoenix/asset_management.html#esbuild-plugins) for using esbuild plugins
2. Add a Svelte ESBuild plugin such as [esbuild-svelte](https://www.npmjs.com/package/esbuild-svelte)
3. Adding `svelte` as a dev dependency to your assets `npm install --save-dev svelte --prefix assets`

If you are only **using** Svelte components as opposed to writing your own, you should be able to skip this step.

## Installation

- Follow the instructions from [the Komodo library](https://github.com/hungry-egg/komodo) to render js apps with Phoenix Liveview.

- Add the npm dependency `komodo-svelte` in the `assets` folder, e.g.

```
npm install --save komodo-svelte --prefix assets
```

## Usage

If we have a Svelte `Counter` component that we would normally use in Svelte like so

```svelte
<Counter
  counter={4}
  on:inc={(event) => console.log(`Increment by ${event.detail}`)}
/>
```

then we can render it from a LiveView with

```elixir
  def render(assigns) do
    ~H"""
      <.js_app
        id="my-counter"
        component="Counter"
        props={%{counter: @counter}}
        callbacks={%{inc: "increment"}}
      />
    """
  end

  def handle_event("increment", %{amount: amount}, socket) do
    IO.puts("Increment by #{amount}")
    {:noreply, socket}
  end
```

To do the above you need configure the hook in your `app.js` like so:

```diff
// ...
import { createJsApps } from "komodo";
+import createSvelteApp from "komodo-svelte";
+import Counter from "path/to/svelte/counter/component.svelte";
// ...

let liveSocket = new LiveSocket("/live", Socket, {
  // ...
  hooks: {
    // ...
    komodo: createJsApps({
      // ...
+      Counter: createSvelteApp(Counter, {
+        // not needed if you don't need to map callback params
+        callbackParams: {
+          inc: (event) => ({ amount: event.detail }),
+        },
+      }),
    }),
  },
});

// ...
```

If you don't map `callbackParams` then `handle_event` will be called with an empty map `%{}`.
In that case you can omit the options arg to createSvelteApp in `app.js`:

```js
Counter: createSvelteApp(Counter);
```
