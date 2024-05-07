import { createElement } from "react";
import { Root, createRoot } from "react-dom/client";
import { JsApp } from "appipelago";

const createReactApp = (
  Component
): JsApp<{
  root: Root;
  callbackProps: Record<string, (...args: any[]) => void>;
}> => ({
  mount(el, props, callbackNames, emit) {
    const root = createRoot(el);
    const callbackProps = callbackNames.reduce(
      (cp, name) => ({ ...cp, [name]: (...args) => emit(name, ...args) }),
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
