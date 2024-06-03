import { App, createApp, h, reactive } from "vue";
import { JsComponent } from "komodo";

const componentFromVue = (
  Component
): JsComponent<{ app: App<Element>; props: Record<string, any> }> => ({
  mount(el, initialProps, callbackNames, emit) {
    const callbackProps = callbackNames.reduce(
      (cp, name) => ({
        ...cp,
        ["on" + name.replace(/^[\w]/, (ch) => ch.toUpperCase())]: (...args) =>
          emit(name, ...args),
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

export default componentFromVue;
