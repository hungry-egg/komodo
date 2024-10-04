# React bindings for Komodo Elixir library

## Installation

- Follow the instructions from [the Komodo library](https://github.com/hungry-egg/komodo) to render js components with Phoenix Liveview.

- Add the npm dependency `komodo-react` as well as `react` and `react-dom` in the `assets` folder, e.g.

```
npm install --save komodo-react react react-dom --prefix assets
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
        callbacks={%{onIncrement: {"increment", arg()}}}
      />
    """
  end

  def handle_event("increment", amount, socket) do
    IO.puts("Increment by #{amount}")
    {:noreply, socket}
  end
```

To do the above you need configure the hook in your `app.js` like so:

```diff
// ...
import { registerJsComponents } from "komodo";
+import componentFromReact from "komodo-react";
+import Counter from "path/to/react/counter/component";
// ...

let liveSocket = new LiveSocket("/live", Socket, {
  // ...
  hooks: {
    // ...
    komodo: registerJsComponents({
      // ...
+      Counter: componentFromReact(Counter)
    }),
  },
});
```
