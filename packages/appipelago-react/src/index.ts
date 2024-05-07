import { createElement } from "react";
import { Root, createRoot } from "react-dom/client";
import { JsApp } from "appipelago";

const createReactApp = (
  Component,
  opts: {
    callbackParams?: Record<string, (...args: any[]) => Record<string, any>>;
  } = {}
): JsApp<{
  root: Root;
  callbackProps: Record<string, (...args: any[]) => void>;
}> => ({
  mount(el, props, callbacks, pushEvent) {
    const root = createRoot(el);
    const callbackProps = Object.keys(callbacks).reduce(
      (cp, key) => ({
        ...cp,
        [key]: (...args) =>
          pushEvent(callbacks[key], opts.callbackParams?.[key](...args)),
      }),
      {}
    );
    root.render(createElement(Component, { ...props, ...callbackProps }));
    return { root, callbackProps };
  },

  update({ root, callbackProps }, props) {
    root.render(createElement(Component, { ...props, ...callbackProps }));
  },

  unmount({ root }) {
    root.unmount();
  },
});

export default createReactApp;
