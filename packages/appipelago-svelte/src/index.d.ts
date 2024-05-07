import { SvelteComponent } from "svelte";
declare const createSvelteApp: (Component: any, opts?: {
    callbackParams?: Record<string, (...args: any[]) => Record<string, any>>;
}) => JsApp<{
    app: SvelteComponent;
}>;
export default createSvelteApp;
