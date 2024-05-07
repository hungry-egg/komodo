import { JsApp } from "../js-app.js";

export const createJsApps = (apps: Record<string, JsApp<any>>) => ({
  mounted() {
    const componentName = this.el.dataset.name;
    this.adapter = apps[componentName];
    if (!this.adapter) {
      throw new Error(
        `Couldn't find JS app adapter for "${componentName}" - have you added it to the list of apps in the jsApp hook?`
      );
    }
    const props = JSON.parse(this.el.dataset.props);
    const callbacks = JSON.parse(this.el.dataset.callbacks);
    this.mountReturnValue = this.adapter.mount(
      this.el,
      props,
      callbacks,
      (event: string, payload: any) => this.pushEvent(event, payload)
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
