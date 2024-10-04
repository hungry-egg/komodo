export type ArgSpec = { __arg__: number; path: (number | string)[] };

export const argSpec = (num: number, path = []): ArgSpec => ({
  __arg__: num,
  path,
});

export const isArgSpec = (obj: any): obj is ArgSpec =>
  obj && typeof obj.__arg__ === "number" && Array.isArray(obj.path);
