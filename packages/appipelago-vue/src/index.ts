import { App, createApp, h, reactive } from "vue";
import { JsApp } from "appipelago";

const createVueApp = (
  Component,
  opts: {
    callbackParams?: Record<string, (...args: any[]) => Record<string, any>>;
  } = {}
): JsApp<{ app: App<Element>; props: Record<string, any> }> => ({
  mount(el, initialProps, callbacks, pushEvent) {
    const callbackProps = Object.keys(callbacks).reduce(
      (cp, key) => ({
        ...cp,
        ["on" + key.replace(/^[\w]/, (ch) => ch.toUpperCase())]: (...args) =>
          pushEvent(callbacks[key], opts.callbackParams?.[key](...args)),
      }),
      {}
    );
    const props = reactive(initialProps);
    const app = createApp({
      render: () =>
        h(Component, {
          ...props,
          ...callbackProps,
        }),
    });
    app.mount(el);
    return { app, props };
  },

  update({ props }, newProps) {
    Object.assign(props, newProps);
  },

  unmount({ app }) {
    app.unmount();
  },
});

export default createVueApp;
