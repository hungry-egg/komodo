import { isArgSpec } from "./arg-spec.js";

/**
 * Parse a payload given a payload spec and a set of arguments
 * If it encounters something in the payload spec that looks like `{__arg__: num, path: [...]}`
 * then it will replace it with a value extracted from the specified arg
 *
 * Examples:
 * ```
 * // Ignore the args
 * parsePayload({some: "payload"}, [event]) // ==> {some: "payload"}

 * // Extract a part of the arg
 * parsePayload({__arg__: 1, path: ["clientX"]}, [event]) // ==> 64

 * // A combination
 * parsePayload({id: "myId", clientX: {__arg__: 1, path: ["clientX"]}}, [event]) // ==> {id: "myId", clientX: 64}
 *
 * ```
 */
export const parsePayload = (payloadSpec: any, args: any[]) => {
  if (Array.isArray(payloadSpec)) {
    return payloadSpec.map((ps) => parsePayload(ps, args));
  } else if (isArgSpec(payloadSpec)) {
    return getIn(args, [payloadSpec.__arg__ - 1, ...payloadSpec.path]);
  } else if (typeof payloadSpec === "object") {
    return Object.fromEntries(
      Object.entries(payloadSpec).map(([key, ps]: [string, string]) => [
        key,
        parsePayload(ps, args),
      ])
    );
  } else {
    return payloadSpec;
  }
};

const getIn = (obj: any, path: (number | string)[]) => {
  let current = obj;

  // Iterate over each key in the path
  for (let key of path) {
    // Check if the key exists
    if (key in current) {
      current = current[key];
    } else {
      // Return undefined if any key in the path does not exist
      return undefined;
    }
  }

  // Return the final value reached by the path, or undefined if not found
  return current;
};
