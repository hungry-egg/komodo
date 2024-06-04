import { describe, expect, it } from "@jest/globals";
import { extractFromObject } from "../../src/helpers/extract-from-object.js";

describe("extractFromObject", () => {
  it("extracts correctly given a string path spec", () => {
    expect(extractFromObject({ a: { b: 3 } }, "a.b")).toEqual(3);
  });

  it("extracts correctly given an array path spec", () => {
    expect(
      extractFromObject({ a: { b: 3 }, x: { y: 7 } }, ["a.b", "x.y"])
    ).toEqual([3, 7]);
  });

  it("extracts correctly given an object path spec", () => {
    expect(
      extractFromObject(
        { a: { b: 3 }, x: { y: 7 } },
        { first: "a.b", second: "x.y" }
      )
    ).toEqual({ first: 3, second: 7 });
  });

  it("returns undefined if not found", () => {
    expect(extractFromObject({ a: { b: 1 } }, "what.the")).toBeUndefined();
    expect(extractFromObject({ a: { b: 1 } }, ["what.the"])).toEqual([
      undefined,
    ]);
    expect(extractFromObject({ a: { b: 1 } }, { first: "what.the" })).toEqual({
      first: undefined,
    });
  });
});
