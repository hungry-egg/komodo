# Appipelago

Helpers for rendering components from typical single-page-app frameworks from Phoenix LiveView.

Works with adapters for different frameworks, e.g.

- [Svelte adapter](https://github.com/hungry-egg/appipelago/tree/main/packages/svelte)
- [React adapter](https://github.com/hungry-egg/appipelago/tree/main/packages/react)
- [Vue adapter](https://github.com/hungry-egg/appipelago/tree/main/packages/vue)

![Demo](images/multi-app.gif)

## Installation

This package is [on Hex](https://hexdocs.pm/appipelago), so you can add`appipelago` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:appipelago, "~> x.x.x"} # check latest with mix hex.search appipelago
  ]
end
```

and run `mix deps.get`.

Add the javascript library to your assets `package.json`:

```js
"dependencies": {
  // ...
  "appipelago": "file:../deps/appipelago"
}
```

and install - `npm install --prefix assets`.

## Setup

Given a Phoenix app `MyApp`:

1. Import the provided components for use in heex templates

In `my_app_web.ex`:

```diff
defmodule MyAppWeb do

  # ...

  def html_helpers do
    # ...
+    import Appipelago.Components
    # ...
  end

  # ...
end
```

2. Add the provided hook to the LiveSocket

In `app.js`:

```diff
// ...
+ import { createJsApps } from "appipelago";

// ...

let liveSocket = new LiveSocket("/live", Socket, {
  // ...
  hooks: {
+    appipelago: createJsApps({
+      // individual JS components will go here
+    })
  }
});

// ...
```

## Rendering a component from LiveView

See documentation for the particular adapter you're using, e.g. one of

- [Svelte adapter](https://github.com/hungry-egg/appipelago/tree/main/packages/svelte)
- [React adapter](https://github.com/hungry-egg/appipelago/tree/main/packages/react)
- [Vue adapter](https://github.com/hungry-egg/appipelago/tree/main/packages/vue)

## Custom Adapters

Adapters for each framework are small and easy to write for new libraries.
TODO: doc here.
