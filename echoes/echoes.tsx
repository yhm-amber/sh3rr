export 
const echoes = 
(ffs: {[key: string]: (env: { [key: string]: Function }) => Function})
: {[key: string]: Function} =>
    Object.entries(ffs).reduce
    (
        (env, [fn, f]) => ({... env, [fn]: f(env)}) ,
        {} as {[key: string]: Function}
    ) ;
