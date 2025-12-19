{if $settings.abt__ut2.general.bfcache.{$settings.abt__device} === "YesNo::YES"|enum}
    <script data-no-defer>
        {literal}
        window.WebSocket = new Proxy(window.WebSocket, {
            construct(target, args) {
                const ws = new target(...args);
                const wsEvents = ['close', 'error', 'message', 'open'];

                window._websockets = window._websockets || new Map();
                window._websockets.set(ws, {});

                const removeWs = (target) => {
                    window._websockets.remove(target);
                }

                ws.close = new Proxy(ws.close, {
                    apply(target, thisArg, args) {
                        if (args[0] !== 4444) removeWs(thisArg);
                        return target.apply(thisArg, args);
                    }
                });

                const addEventListenerProxy = new Proxy(ws.addEventListener, {
                    apply(target, thisArg, args) {
                        const [e, func] = args;
                        if (window._websockets.has(thisArg)) {
                            window._websockets.get(thisArg)[e]?.push(func) || (window._websockets.get(thisArg)[e] = [func]);
                        }

                        return target.apply(thisArg, args);
                    }
                });

                ws.addEventListener = addEventListenerProxy;

                wsEvents.forEach((e) => {
                    Object.defineProperty(ws, 'on' + e, {
                        set(func) {
                            const callback = function (event) {
                                func.call(this, event);
                            };
                            return addEventListenerProxy.apply(this, [
                                e,
                                callback,
                                false
                            ]);
                        }
                    });
                });

                return ws;
            }
        });
        {/literal}
    </script>
{/if}