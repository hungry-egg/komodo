type Emit = (eventName: string, ...args: any[]) => void;

export type JsComponent<TMountReturnValue extends Record<string, any>> = {
  mount: (
    el: HTMLElement,
    props: Record<string, any>,
    callbackNames: string[],
    emit: Emit
  ) => TMountReturnValue;
  update: (context: TMountReturnValue, props: Record<string, any>) => void;
  unmount: (context: TMountReturnValue) => void;
};
