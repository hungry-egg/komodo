import { extractFromObject } from "../extract-from-object.js";
import { JsApp } from "../js-app.js";

export const createJsApps = (apps: Record<string, JsApp<any>>) => ({
  mounted() {
    const componentName = this.el.dataset.name;
    this.adapter = apps[componentName];
    if (!this.adapter) {
      throw new Error(
        `Couldn't find JS app adapter for "${componentName}" - have you added it to the list of apps in the appipelago hook?`
      );
    }
    const props = JSON.parse(this.el.dataset.props);
    const callbacks = JSON.parse(this.el.dataset.callbacks);
    this.mountReturnValue = this.adapter.mount(
      this.el,
      props,
      Object.keys(callbacks),
      (callbackName: string, ...args: any[]) => {
        const [eventName, payloadSpec] = callbacks[callbackName];
        const payload = extractFromObject(args, payloadSpec);
        this.pushEvent(eventName, payload);
      }
    );
  },

  updated() {
    const props = JSON.parse(this.el.dataset.props);
    this.adapter.update(this.mountReturnValue, props);
  },

  destroyed() {
    this.adapter.unmount(this.mountReturnValue);
  },
});
