namespace Echoes
{
    export 
    const echoes =
    <T = {[key: string]: any},> (waves: {[key: string]: (env: T) => any})
    : T =>
        Object.entries(waves).reduce
        (
            (envs, [fn, f]) => ({... envs, [fn]: f(envs)}) ,
            {} as T
        ) ;

    export 
    const call = 
    <T extends Record<K, (...args: any) => any>, K extends keyof T>
    (obj: T, key: K): { [P in K]: ReturnType<T[P]>; }[K] =>
        echoes<{[P in K]: ReturnType<T[P]>}>(obj)[key] ;
    
} ;
