--#[ Types ]#--
type userdata = typeof(newproxy(true))

export type main = {
    func: mkFunc;
    event: mkEvent;
    getProp: getProp;
    setProp: setProp;
    setProps: setProps;
    destroyer: destroyer;
    null: userdata;
} & ((className: string) -> ((classConfig: classConfig) -> (class))) & ((classConfig: classConfig) -> (class))

export type class = {
    new: (...any) -> any;

    objectCreated: Signal;
    objectDestroyed: Signal;
    childClassCreated: Signal;
}

export type classConfig = { mkFuncResult | mkEventResult }

export type mkFunc = (funcName: string) -> ((runner: (...any) -> ...any) -> (mkFuncResult))
export type mkFuncResult = {
    name: string;
    funcType: "method" | "default" | "magic" | "unknownFunc";
    runner: (...any) -> ...any;
} & (runner: (...any) -> ...any) -> mkFuncResult

export type mkEvent = (eventName: string) -> ()
export type mkEventResult = { name: string }

export type getProp = (object: userdata, key: string) -> any?
export type setProp = (object: userdata, key: string, value: any) -> nil
export type setProps = (object: userdata) -> ((props: { [string]: any }) -> nil)
export type destroyer = (object: userdata) -> userdata

export type Connection<U...> = { --// from the LemonSignal
	Connected: boolean,

	Disconnect: (self: Connection<U...>) -> (),
	Reconnect: (self: Connection<U...>) -> (),
}

export type Signal<T...> = { --// from the LemonSignal
	RBXScriptConnection: RBXScriptConnection?,

	Connect: <U...>(self: Signal<T...>, fn: (...any) -> (), U...) -> Connection<U...>,
	Once: <U...>(self: Signal<T...>, fn: (...any) -> (), U...) -> Connection<U...>,
	Wait: (self: Signal<T...>) -> T...,
	Fire: (self: Signal<T...>, T...) -> (),
	DisconnectAll: (self: Signal<T...>) -> (),
	Destroy: (self: Signal<T...>) -> (),
}

return nil