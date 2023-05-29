namespace fp
{
    
    type Fn <T, R> = (p: T) => R ;
    
    
    
    export 
    const memoize = 
    <T extends (...args: any[]) => any> (fn: T)
    : T => 
    {
        const cache: Record<string, ReturnType<T>> = {};
        
        return ((...args: Parameters<T>)
        : ReturnType<T> => 
        {
            const key = JSON.stringify(args) ;
            if (!(key in cache)) 
            { cache[key] = fn(...args); } ;
            return cache[key] ;
        }) as T ;
    } ;
    
    
    
    export 
    const apply = 
    <T,> (f: Function, args: any[], that: T|undefined = undefined)
    : any => 
        
        f.call(that, ...args) ;
    
    export 
    const applieds = memoize(apply) ;
    
    
    
    export 
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
        <T extends Record<K, (...args: any) => any>, K extends keyof T> (obj: T, key: K)
        : { [P in K]: ReturnType<T[P]> ; }[K] => 
            echoes <{[P in K]: ReturnType<T[P]> }>(obj) [key] ;
        
    } ;
    
    
    
    export 
    class Pipe
    <T> 
    {
        constructor 
        (
            private readonly value: T , 
            private readonly fns: Fn<any, any>[] = [] , 
            private readonly piperunner
                : <T> (funcs: Fn<any, any>[], v: T) => T = 
            memoize
            (
                <T,> (fs: Fn<any, any>[], v: T)
                : T => 
                    fs.reduce((r, f) => f(r), v)
            ) , 
        ) 
        {} ;
        
        
        private readonly runfn = 
        ()
        : T => 
            
            this.piperunner(this.fns, this.value) ;
        
        
        readonly then = 
        <R,> (fn: Fn<T, R>)
        : Pipe<R> => 
        {
            this.fns.push(fn);
            return (this as unknown) as Pipe<R> ;
        } ;
        
        
        readonly run = 
        ()
        : Pipe<T> => 
            
            new Pipe(this.runfn(), [], this.piperunner) ;
        
        
        readonly pipi = 
        <R,> (fn: Fn<T, R>)
        : Pipe<T> => 
        {
            fn(this.runfn());
            return new Pipe(this.value, this.fns, this.piperunner) ;
        } ;
        
        readonly pop = 
        (): T => this.value ;
    } ;
    
    
    
    export 
    class Stream
    <T> 
    {
        
        constructor 
        (private readonly generatorFunction: () => Generator<T>) 
        {} ;
        
        
        static readonly iterate = 
        <T,> (initialValue: T, f: Fn<T, T>)
        : Stream<T> => 
            
            new Stream
            ( function* ()
            : Generator<T> 
            {
                let value = initialValue;
                while (true) 
                {
                    yield value ;
                    value = f(value);
                } ;
            } ) ;
        
        
        static readonly unfold = 
        <T, R> (initialValue: T, f: Fn<T, { mapper: R; iter: T } | undefined>)
        : Stream<R> => 
            
            new Stream
            ( function* ()
            : Generator<R> 
            {
                let value = initialValue;
                let next: { mapper: R, iter: T } | undefined = f(value);
                
                while (!(next === undefined)) 
                {
                    yield next.mapper ;
                    
                    value = next.iter;
                    next = f(value);
                } ;
            } ) ;
        
        
        readonly map = 
        <R,> (f: Fn<T, R>)
        : Stream<R> => 
            
            new Stream
            (( function* (this: Stream<T>)
            : Generator<R> 
            {
                const iterator = this.generatorFunction() ;
                while (true) 
                {
                    const { value, done } = iterator.next() ;
                    if (done) break;
                    yield f(value) ;
                } ;
            } ).bind(this)) ;
        
        
        readonly filter = 
        (predicate: Fn<T, boolean>)
        : Stream<T> => 
            
            new Stream
            (( function* (this: Stream<T>)
            : Generator<T> 
            {
                const iterator = this.generatorFunction() ;
                while (true) 
                {
                    const { value, done } = iterator.next() ;
                    if (done) break;
                    if (predicate(value)) yield value ;
                }
            } ).bind(this)) ;
        
        
        readonly takeUntil = 
        (predicate: Fn<T, boolean>)
        : T[] => 
        {
            const result: T[] = [] ;
            const iterator = this.generatorFunction() ;
            while (true) 
            {
                const { value, done } = iterator.next() ;
                result.push(value);
                if (done || predicate(value)) break;
            } ;
            return result ;
        } ;
        
        readonly take = 
        (n: number)
        : T[] => 
        {
            let count = 1;
            return this.takeUntil(() => !(count++ < n));
        } ;
    } ;
    
    
    
    export 
    class TailCall
    <T> 
    {
        
        constructor 
        (
            public readonly isComplete: boolean , 
            public readonly result: T , 
            public readonly nextCall: () => TailCall<T> , 
        ) 
        {} ;
        
        
        static readonly done = 
        <T,> (value: T)
        : TailCall<T> => 
            
            new TailCall(true, value, () => { throw new Error("TailCall.done: not implemented"); }) ;
        
        
        static readonly call = 
        <T,> (nextCall: () => TailCall<T>)
        : TailCall<T> => 
            
            new TailCall(false, null as any, nextCall) ;
        
        
        readonly invoke = 
        (): T => 
            
            Stream
                .iterate(this as TailCall<T>, x => (x.nextCall()))
                .takeUntil(x => x.isComplete)
                .reduce((_, x) => x.result, this.result) ;
        
    } ;
} ;




namespace Demos
{
    console.log("-------- --------");
    
    
    namespace Memoizes
    {
        export namespace treerec
        {
            export const fib = fp.memoize((n: number): number => (n <= 1 ? n : fib(n - 1) + fib(n - 2)) ) ;
        } ;
        
    } ;
    console.log(Memoizes.treerec.fib(40) );
    console.log(Memoizes.treerec.fib(40) );
    
    
    
    namespace Applies
    {
        export const simple = () =>
        {
            console.log(fp.apply((a: number) => a+12, [3]) );
        } ;
        
        export const pipedsimple = () =>
        {
            new fp.Pipe(fp.apply((a: number, b: string) => b + (a*2), [3, "x"]) )
                .then(x => console.log(x))
                .run();
        } ;
    } ;
    Applies.simple();
    Applies.pipedsimple();
    
    namespace Appliedses
    {
        export namespace treerec
        {
            export const fiba = (n: number): number => (n <= 1 ? n : fp.applieds(fiba,[n - 1]) + fp.applieds(fiba,[n - 2]) ) ;
            export const fib = (n: number): number => fp.applieds(fiba,[n]) ;
        } ;
    } ;
    console.log(Appliedses.treerec.fiba(41) );
    console.log(Appliedses.treerec.fib(41) );
    
    
    
    namespace Echoeses
    {
        export namespace simple
        {
            export const ffs =
            {
                f1: (env: { [key: string]: Function }) => 
                    
                    (n: number): number => 1 + n ,
                
                f2: (env: { [key: string]: Function }) => 
                    
                    (x: number): number => env.f1(x * 2) ,
                
            } ;
        } ;
        
        export namespace more
        {
            export const xx =
            {
                x0: (env: { [key: string]: any }) => 
                    
                    1 ,
                
                f: (env: { [key: string]: any }) => 
                    
                    (s: string)
                    : number => 
                        s.length ,
                
                f2: (env: { [key: string]: any }) => 
                    
                    (s: string, n: number)
                    : Promise<number> => 
                        Promise.resolve(env.f(s) + n - env.x0) ,
            } ;
        } ;
        
        export const runs = () =>
        {
            console.log(fp.Echoes.echoes(Echoeses.simple.ffs).f2(3) ); // out: 7
            
            
            fp.Echoes
                .echoes<{f2: ReturnType<typeof Echoeses.more.xx.f2>}>(Echoeses.more.xx).f2('aa',3)
                .then(r => console.log(`Promising: Echoeses.more I: ${r}`)); // out: 4
            
            fp.Echoes
                .echoes(Echoeses.more.xx).f2('aaa',3)
                .then( (r: number) => console.log(`Promising: Echoeses.more II: ${r}`) ); // out: 5
            
            fp.Echoes
                .call(Echoeses.more.xx,'f2')('a',3)
                .then(r => console.log(`Promising: Echoeses.more III: ${r}`)); // out: 3
        } ;
    } ;
    Echoeses.runs();
    
    
    
    namespace Pipes
    {
        export const test0 = () =>
        {
            var y, z;
            const result = new fp.Pipe(1)
                .then(x => x + 1)
                .then(x => x * x)
                .then(x => x.toString())
                .then(x => x.toString())
                .run()
                .then(x => x + 5)
                .then(x => x + 0)
                .pipi(x => (y = x + 1))
                .pipi(x => (z = x + 1))
                .then(x => x + "c")
                // .run()
                .pop();
            
            console.log(result);
            console.log(y);
            console.log(z);
        } ;
        
    } ;
    Pipes.test0();
    
    
    
    
    namespace Streams
    {
        export const unfolds =
        {
            simple: 
                
                fp.Stream.unfold(0, x => x < 10 ? { mapper: x, iter: x + 1 } : undefined ) ,
            
            fibs: 
                
                fp.Stream.unfold
                (
                    { x: 0, y: 0, z: 1 },
                    ({ x, y, z }) => ({ mapper: { x, y }, iter: { x: x + 1, y: z, z: y + z } })
                ) ,
            
        } ;
        
        export const iterates =
        {
            fibs: 
                
                fp.Stream
                    .iterate({x: 0, y: 0,z: 1}, ({ x, y, z }) => ({ x: x + 1, y: z, z: y + z }))
                    .map(({ x, y, z }) => ({ x, y })) ,
            
        } ;
    } ;
    console.log(Streams.unfolds.simple.take(16) );
    console.log(Streams.unfolds.fibs.take(4) );
    console.log(Streams.iterates.fibs.take(4) );
    console.log(Streams.unfolds.fibs.filter(({ x, y }) => x % 2 === 1).take(14) );
    console.log(Streams.unfolds.fibs.take(14).filter(({ x, y }) => x % 2 === 1) );
    
    
    
    namespace Tailcalls
    {
        export namespace simplecases
        {
            
            export 
            const rb =
            (n: number, r: number)
            : fp.TailCall<number> =>
                
                (n < r) ? fp.TailCall.done(n) 
                : fp.TailCall.call(() => rb(n-r, r)) ;
        } ;
        
        export namespace morecases
        {
            export 
            const factorial = 
            (n: number): number =>
            {
                const iter = 
                (acc: number, n: number)
                : fp.TailCall<number> =>
                    
                    (n === 1) ? fp.TailCall.done(acc) 
                    : fp.TailCall.call(() => iter(n * acc, n - 1)) ;
                
                return iter(1, n).invoke() ;
            } ;
        } ;
    } ;
    console.log(Tailcalls.simplecases.rb(1000001,2).invoke() );
    console.log(Tailcalls.morecases.factorial(5) );
    
    
} ;

