import { type Component, type SvelteComponent, mount, unmount } from "svelte";
import type { JsComponent } from "komodo";

const componentIsPreSvelte5 = (
  component: Component | SvelteComponent
): component is SvelteComponent =>
  !!component.toString().match(/extends SvelteComponent/);

/**
 * This works with version 5 of Svelte and above - for previous versions you'll need v0.0.1 of this library
 */
const componentFromSvelte = (
  component: Component | SvelteComponent
): JsComponent<{
  app: Record<string, any>;
  props: Record<string, unknown>;
}> => ({
  mount(el, initialProps, callbackNames, emit) {
    if (componentIsPreSvelte5(component))
      throw new Error(
        "You passed a component to componentFromSvelte that appears to be from a pre-v5 version of Svelte.\n" +
          "Either use a more up-to-date component or use komodo-svelte version 0.0.1."
      );
    const callbackProps = callbackNames.reduce(
      (cp, name) => ({
        ...cp,
        [name]: (...args: any[]) => emit(name, ...args),
      }),
      {}
    );
    const props = $state({ ...initialProps, ...callbackProps });
    const app = mount(component, {
      target: el,
      props,
    });
    return { app, props };
  },

  update({ props }, newProps) {
    Object.entries(newProps).forEach(([key, newValue]) => {
      const oldValue = props[key];
      if (
        oldValue !== undefined &&
        typeof oldValue !== "function" &&
        newValue !== oldValue
      ) {
        props[key] = newValue;
      }
    });
  },

  unmount({ app }) {
    unmount(app);
  },
});

export default componentFromSvelte;
