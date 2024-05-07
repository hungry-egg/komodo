import { SvelteComponent } from "svelte";
import { JsApp } from "@appipelago/core";

const createSvelteApp = (
  Component,
  opts: {
    callbackParams?: Record<string, (...args: any[]) => Record<string, any>>;
  } = {}
): JsApp<{ app: SvelteComponent }> => ({
  mount(el, initialProps, callbacks, pushEvent) {
    const app = new Component({
      target: el,
      props: initialProps,
    });
    Object.entries(callbacks).forEach(
      ([svelteEventName, liveViewEventName]) => {
        app.$on(svelteEventName, (event: CustomEvent) => {
          pushEvent(
            liveViewEventName,
            opts.callbackParams?.[svelteEventName](event)
          );
        });
      }
    );
    return { app };
  },

  update({ app }, newProps) {
    app.$set(newProps);
  },

  unmount({ app }) {
    app.$destroy();
  },
});

export default createSvelteApp;
