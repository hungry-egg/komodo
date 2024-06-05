import { JsComponent } from "../js-component.js";

export const componentFromElement = (
  tagName: string
): JsComponent<{
  element: HTMLElement;
  subscriptions: [eventName: string, listener: EventListener][];
}> => ({
  mount(el, initialProps, callbackNames, emit) {
    const element = document.createElement(tagName);
    // Props
    Object.assign(element, initialProps);
    // Callbacks
    const subscriptions: [string, EventListener][] = callbackNames.map(
      (eventName) => {
        const listener: EventListener = (event) => emit(eventName, event);
        element.addEventListener(eventName, listener);
        return [eventName, listener];
      }
    );
    // Attach element
    el.appendChild(element);
    return { element, subscriptions };
  },

  update({ element }, newProps) {
    Object.assign(element, newProps);
  },

  unmount({ element, subscriptions }) {
    // Unsubscribe callbacks
    subscriptions.forEach(([eventName, listener]) =>
      element.removeEventListener(eventName, listener)
    );
  },
});
