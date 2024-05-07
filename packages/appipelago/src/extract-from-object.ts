type ObjectPath = string;
type PathSpec = ObjectPath | ObjectPath[] | Record<string, ObjectPath>;

export const extractFromObject = (obj: any, pathSpec: PathSpec) => {
  if (Array.isArray(pathSpec)) {
    return pathSpec.map((ps) => extractFromObject(obj, ps));
  } else if (typeof pathSpec === "string") {
    const path = pathSpec.split(".");
    return getIn(obj, path);
  } else if (typeof pathSpec === "object") {
    return Object.fromEntries(
      Object.entries(pathSpec).map(([key, ps]: [string, string]) => [
        key,
        extractFromObject(obj, ps),
      ])
    );
  } else {
    return;
  }
};

const getIn = (obj: any, path: string[]) => {
  let current = obj;

  // Iterate over each key in the path
  for (let key of path) {
    // Check if the key exists and is not null
    if (current && key in current) {
      current = current[key];
    } else {
      // Return undefined if any key in the path does not exist
      return undefined;
    }
  }

  // Return the final value reached by the path, or undefined if not found
  return current;
};
