import { extractFromObject } from "./extract-from-object.js";
import { JsApp } from "./js-app.js";

/**
 * Creates a hook compatible with Phoenix Liveview
 * @param apps: Record<string, JsApp> - a register of JS apps, keyed by name
 */
export const createJsApps = (apps: Record<string, JsApp<any>>) => ({
  mounted() {
    const appName = this.el.dataset.name;
    this.app = apps[appName];
    if (!this.app) {
      throw new Error(
        `Couldn't find JS app for "${appName}" - have you added it to the list of apps in the appipelago hook?`
      );
    }
    const props = JSON.parse(this.el.dataset.props);
    const callbacks = JSON.parse(this.el.dataset.callbacks);
    this.mountReturnValue = this.app.mount(
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
    this.app.update(this.mountReturnValue, props);
  },

  destroyed() {
    this.app.unmount(this.mountReturnValue);
  },
});
