# React bindings for Komodo Elixir library

## Installation

- Follow the instructions from [the Komodo library](https://github.com/hungry-egg/komodo) to render js apps with Phoenix Liveview.

- Add the npm dependency `komodo-react` in the `assets` folder, e.g.

```
npm install --save komodo-react --prefix assets
```

## Usage

If we have a React `Counter` component that we would normally use in React like so

```jsx
<Counter
  counter={4}
  onIncrement={(amount) => console.log(`Increment by ${amount}`)}
/>
```

then we can render it from a LiveView with

```elixir
  def render(assigns) do
    ~H"""
      <.js_component
        id="my-counter"
        component="Counter"
        props={%{counter: @counter}}
        callbacks={%{onIncrement: "increment"}}
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
import { createJsComponents } from "komodo";
+import createReactApp from "komodo-react";
+import Counter from "path/to/react/counter/component";
// ...

let liveSocket = new LiveSocket("/live", Socket, {
  // ...
  hooks: {
    // ...
    komodo: createJsComponents({
      // ...
+      Counter: createReactApp(Counter, {
+        // not needed if you don't need to map callback params
+        callbackParams: {
+          onIncrement: (amount) => ({ amount }),
+        },
+      }),
    }),
  },
});

// ...
```

If you don't map `callbackParams` then `handle_event` will be called with an empty map `%{}`.
In that case you can omit the options arg to createReactApp in `app.js`:

```js
Counter: createReactApp(Counter);
```
