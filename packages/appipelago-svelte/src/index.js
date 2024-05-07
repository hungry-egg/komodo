const createSvelteApp = (Component, opts = {}) => ({
    mount(el, initialProps, callbacks, pushEvent) {
        const app = new Component({
            target: el,
            props: initialProps,
        });
        Object.entries(callbacks).forEach(([svelteEventName, liveViewEventName]) => {
            app.$on(svelteEventName, (event) => {
                var _a;
                pushEvent(liveViewEventName, (_a = opts.callbackParams) === null || _a === void 0 ? void 0 : _a[svelteEventName](event));
            });
        });
        return { app };
    },
    update({ app }, newProps) {
        app.$set(newProps);
    },
    unmount({ app }) {
        app.$destroy();
    },
});
export default createSvelteApp;
//# sourceMappingURL=index.js.map