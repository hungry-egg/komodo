import { describe, expect, it } from "@jest/globals";
import { parsePayload } from "../../src/helpers/parse-payload.js";
import { argSpec } from "../../src/helpers/arg-spec.js";

describe("parsePayload", () => {
  const event = {
    detail: { coord: [77, 33] },
    clientX: 32,
  };

  it("passes through unchanged if a static payload spec is given", () => {
    expect(
      parsePayload({ payload: "spec", is: ["here", "yay"] }, [event])
    ).toEqual({
      payload: "spec",
      is: ["here", "yay"],
    });
  });

  it("extracts an arg if an arg spec is given", () => {
    expect(parsePayload(argSpec(1), [event])).toEqual(event);
  });

  it("extracts a path within an arg if an arg spec with path is given", () => {
    expect(parsePayload(argSpec(1, ["detail", "coord", 1]), [event])).toEqual(
      33
    );
  });

  it("works with different numbered args", () => {
    expect(parsePayload(argSpec(2), [event, "second"])).toEqual("second");
  });

  it("extracts an arg if given as part of an array", () => {
    expect(parsePayload(["hi", argSpec(1, ["clientX"])], [event])).toEqual([
      "hi",
      32,
    ]);
  });

  it("extracts an arg if given as part of an object", () => {
    expect(
      parsePayload({ first: "hi", second: argSpec(1, ["clientX"]) }, [event])
    ).toEqual({ first: "hi", second: 32 });
  });

  it("works if the arg spec is nested deeply", () => {
    expect(
      parsePayload(
        { a: { b: { c: [true, argSpec(1, ["detail", "coord", 1])] } } },
        [event]
      )
    ).toEqual({ a: { b: { c: [true, 33] } } });
  });

  it("returns undefined if not found", () => {
    expect(parsePayload(argSpec(1, ["what", "the"]), [event])).toEqual(
      undefined
    );
    expect(parsePayload([argSpec(1, ["what", "the"])], [event])).toEqual([
      undefined,
    ]);
    expect(parsePayload({ key: argSpec(1, ["what", "the"]) }, [event])).toEqual(
      {
        key: undefined,
      }
    );
    expect(parsePayload(argSpec(2, ["clientX"]), [event])).toEqual(undefined);
  });
});
