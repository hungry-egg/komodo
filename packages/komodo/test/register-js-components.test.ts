import { describe, it, jest, beforeEach, expect } from "@jest/globals";
import { JsComponent } from "../src/js-component.js";
import { registerJsComponents } from "../src/register-js-components.js";
import { argSpec } from "../src/helpers/arg-spec.js";

type El = {
  dataset: { name: string; props: string; callbacks: string };
};

type Hook = {
  el: El;
  pushEvent: (name: string, payload: any) => void;
  mounted: () => void;
  updated: () => void;
  destroyed: () => void;
};

describe("registerJsComponents", () => {
  let hook: Hook;
  let testComponent: JsComponent<{}>;
  let emitEvent: Parameters<JsComponent<any>["mount"]>[3];

  const props = {
    islands: [{ name: "Bali" }, { name: "Flores" }],
    day: "Tuesday",
  };

  const callbacks = {
    selectIndex: ["select_index"],
    dayChanged: [
      "day_changed",
      {
        id: "my-component",
        from: argSpec(1, ["day"]),
        to: argSpec(2, ["day"]),
      },
    ],
  };

  beforeEach(() => {
    testComponent = {
      mount(el, props, callbackNames, emit) {
        emitEvent = emit;
        return "mountReturnVal";
      },

      update: jest.fn(),

      unmount: jest.fn(),
    };

    hook = {
      el: {
        // mock element with dataset
        dataset: {
          name: "myComponent",
          props: JSON.stringify(props),
          callbacks: JSON.stringify(callbacks),
        },
      },
      pushEvent: jest.fn(),
      ...registerJsComponents({
        myComponent: testComponent,
      }),
    };
  });

  it("passes things correctly on mount", () => {
    jest.spyOn(testComponent, "mount");
    hook.mounted();
    expect(testComponent.mount).toHaveBeenCalledWith(
      hook.el,
      props,
      ["selectIndex", "dayChanged"],
      expect.any(Function)
    );
  });

  it("maps callbacks correctly", () => {
    jest.spyOn(testComponent, "mount");
    hook.mounted();

    emitEvent("selectIndex");
    expect(hook.pushEvent).toHaveBeenCalledWith("select_index", undefined);

    emitEvent("dayChanged", { day: "Tues" }, { day: "Weds" });
    expect(hook.pushEvent).toHaveBeenCalledWith("day_changed", {
      id: "my-component",
      from: "Tues",
      to: "Weds",
    });
  });

  it("passes the mount return value and new props to update on updated", () => {
    hook.mounted();
    hook.el.dataset.props = JSON.stringify({ some: "new props" });
    hook.updated();
    expect(testComponent.update).toHaveBeenCalledWith("mountReturnVal", {
      some: "new props",
    });
  });

  it("passes the mount return value to unmount on destroyed", () => {
    hook.mounted();
    hook.destroyed();
    expect(testComponent.unmount).toHaveBeenCalledWith("mountReturnVal");
  });
});
