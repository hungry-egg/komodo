import { SvelteComponent } from "svelte";
import { JsComponent } from "komodo";

const createSvelteApp = (Component): JsComponent<{ app: SvelteComponent }> => ({
  mount(el, initialProps, callbackNames, emit) {
    const app = new Component({
      target: el,
      props: initialProps,
    });
    callbackNames.forEach((name) => {
      app.$on(name, (event: CustomEvent) => emit(name, event));
    });
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
