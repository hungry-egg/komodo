module.exports = {
  preset: "ts-jest",
  testEnvironment: "node",
  testMatch: ["**/?(*.)+(spec|test).[jt]s?(x)"],
  moduleNameMapper: {
    // https://stackoverflow.com/questions/73895986/how-to-handle-relative-imports-in-jest-with-esm-modules-written-in-typescript
    "^(\\.{1,2}/.*)\\.js$": "$1",
  },
};
