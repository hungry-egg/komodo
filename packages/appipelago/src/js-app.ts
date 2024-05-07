type PushEvent = (eventName: string, params: any) => void;

export type JsApp<TMountReturnValue extends Record<string, any>> = {
  mount: (
    el: HTMLElement,
    props: Record<string, any>,
    callbacks: Record<string, string>,
    pushEvent: PushEvent
  ) => TMountReturnValue;
  update: (context: TMountReturnValue, props: Record<string, any>) => void;
  unmount: (context: TMountReturnValue) => void;
};
