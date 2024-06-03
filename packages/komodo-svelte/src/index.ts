import { SvelteComponent } from "svelte";
import { JsComponent } from "komodo";

const componentFromSvelte = (
  Component
): JsComponent<{ component: SvelteComponent }> => ({
  mount(el, initialProps, callbackNames, emit) {
    const component = new Component({
      target: el,
      props: initialProps,
    });
    callbackNames.forEach((name) => {
      component.$on(name, (event: CustomEvent) => emit(name, event));
    });
    return { component };
  },

  update({ component }, newProps) {
    component.$set(newProps);
  },

  unmount({ component }) {
    component.$destroy();
  },
});

export default componentFromSvelte;
