import { parsePayload } from "./helpers/parse-payload.js";
import { JsComponent } from "./js-component.js";

/**
 * Creates a hook compatible with Phoenix Liveview
 * @param components: Record<string, JsComponent> - a register of JS components, keyed by name
 */
export const registerJsComponents = (
  components: Record<string, JsComponent<any>>
) => ({
  mounted() {
    const componentName = this.el.dataset.name;
    this.component = components[componentName];
    if (!this.component) {
      throw new Error(
        `Couldn't find JS component for "${componentName}" - have you added it to the list of components in the komodo hook?`
      );
    }
    const props = JSON.parse(this.el.dataset.props);
    const callbacks = JSON.parse(this.el.dataset.callbacks);
    this.mountReturnValue = this.component.mount(
      this.el,
      props,
      Object.keys(callbacks),
      (callbackName: string, ...args: any[]) => {
        const [eventName, payloadSpec] = callbacks[callbackName];
        const payload = parsePayload(payloadSpec, args);
        this.pushEventTo(this.el, eventName, payload);
      }
    );
  },

  updated() {
    const props = JSON.parse(this.el.dataset.props);
    this.component.update(this.mountReturnValue, props);
  },

  destroyed() {
    this.component.unmount(this.mountReturnValue);
  },
});
