import { describe, it, jest, beforeEach, expect } from "@jest/globals";
import { JsApp } from "../src/js-app.js";
import { createJsApps } from "../src/create-js-apps.js";

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

describe("createJsApps", () => {
  let hook: Hook;
  let testApp: JsApp<{}>;
  let emitEvent: Parameters<JsApp<any>["mount"]>[3];

  const props = {
    islands: [{ name: "Bali" }, { name: "Flores" }],
    day: "Tuesday",
  };

  const callbacks = {
    selectIndex: ["select_index"],
    dayChanged: ["day_changed", { from: "0.day", to: "1.day" }],
  };

  beforeEach(() => {
    testApp = {
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
          name: "myApp",
          props: JSON.stringify(props),
          callbacks: JSON.stringify(callbacks),
        },
      },
      pushEvent: jest.fn(),
      ...createJsApps({
        myApp: testApp,
      }),
    };
  });

  it("passes things correctly on mount", () => {
    jest.spyOn(testApp, "mount");
    hook.mounted();
    expect(testApp.mount).toHaveBeenCalledWith(
      hook.el,
      props,
      ["selectIndex", "dayChanged"],
      expect.any(Function)
    );
  });

  it("maps callbacks correctly", () => {
    jest.spyOn(testApp, "mount");
    hook.mounted();

    emitEvent("selectIndex");
    expect(hook.pushEvent).toHaveBeenCalledWith("select_index", undefined);

    emitEvent("dayChanged", { day: "Tues" }, { day: "Weds" });
    expect(hook.pushEvent).toHaveBeenCalledWith("day_changed", {
      from: "Tues",
      to: "Weds",
    });
  });

  it("passes the mount return value and new props to update on updated", () => {
    hook.mounted();
    hook.el.dataset.props = JSON.stringify({ some: "new props" });
    hook.updated();
    expect(testApp.update).toHaveBeenCalledWith("mountReturnVal", {
      some: "new props",
    });
  });

  it("passes the mount return value to unmount on destroyed", () => {
    hook.mounted();
    hook.destroyed();
    expect(testApp.unmount).toHaveBeenCalledWith("mountReturnVal");
  });
});
