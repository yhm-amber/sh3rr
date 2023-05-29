# fp.ts

~~~
🦪 lazy seq, memorize, tailrec, pipe, apply, ... 👾
~~~



## usage

### `fp.memoize`

#### treerec

~~~ ts
const fib = fp.memoize
(
    (n: number): number => 
        (n <= 1 ? n : fib(n - 1) + fib(n - 2)) 
) ;

console.log(fib(40) ); // out: 102334155, and calcus quickly with less memory.
~~~

### `fp.Echoes`

#### simple

~~~ ts
const ffs =
{
    f1: (env: { [key: string]: Function }) => 
        
        (n: number): number => 1 + n ,
    
    f2: (env: { [key: string]: Function }) => 
        
        (x: number): number => env.f1(x * 2) ,
    
} ;

console.log(fp.Echoes.echoes(ffs).f2(3) ); // out: 7
~~~

#### more

~~~ ts
/* structorized namespace */

const xx =
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


/* use */

Echoes
    .echoes<{f2: ReturnType<typeof xx.f2>}>(xx).f2('aa',3)
    .then(r => console.log(r)); // out: 4

Echoes
    .echoes(xx).f2('aaa',3)
    .then( (r: number) => console.log(r) ); // out: 5

Echoes
    .call(xx,'f2')('a',3)
    .then(r => console.log(r)); // out: 3
~~~

### `fp.Pipe`

~~~ ts
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

console.log(result); // out: "4"
console.log(y); // out: "4501"
console.log(z); // out: "4501"
~~~

~~~ ts
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
    .run()
    .pop();

console.log(result); // out: "450c"
console.log(y); // out: "4501"
console.log(z); // out: "4501"
~~~

### `fp.apply`

#### simple

~~~ ts
console.log(fp.apply((a: number) => a+12, [3]) ); // out: 15

new fp.Pipe(fp.apply((a: number, b: string) => b + (a*2), [3, "x"]) )
    .then(x => console.log(x))
    .run(); // out: "x6"
~~~

### `fp.applides`

#### treerec

~~~ ts
const fiba = (n: number): number => (n <= 1 ? n : fp.applieds(fiba,[n - 1]) + fp.applieds(fiba,[n - 2]) ) ;
const fib = (n: number): number => fp.applieds(fiba,[n]) ;

console.log(fiba(41) ); // out: 165580141, and calcus quickly with less memory.
console.log(fib(41) ); // out: 165580141, and calcus quickly with less memory.
~~~

### `fp.Stream`

Just like stream/lazylist in elixir or scala.

#### simple

~~~ ts
const s = fp.Stream.unfold(0, x => x < 10 ? { mapper: x, iter: x + 1 } : undefined ) ;
console.log(s.take(3)); // out: [0, 1, 2]
~~~

#### fib

~~~ ts
// unfold
const fibs = 
fp.Stream
    .unfold
    (
        { x: 0, y: 0, z: 1 },
        ({ x, y, z }) => ({ mapper: { x, y }, iter: { x: x + 1, y: z, z: y + z } })
    ) ;

// or iterate
const fibs = 
fp.Stream
    .iterate({x: 0, y: 0,z: 1}, ({ x, y, z }) => ({ x: x + 1, y: z, z: y + z }))
    .map(({ x, y, z }) => ({ x, y })) ;

// take

console.log(fibs.take(3) );
console.log(fibs.take(14) );

console.log(fibs.filter(({ x, y }) => x % 2 === 1).take(3) );
console.log(fibs.filter(({ x, y }) => x % 2 === 1).take(14) );
console.log(fibs.take(14).filter(({ x, y }) => x % 2 === 1) );
~~~

### `fp.TailCall`

#### fac

~~~ ts
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

console.log(factorial(5)); // out: 120
~~~

#### rb

[ref]: https://segmentfault.com/a/1190000040173495

~~~ ts
const rb = 
(n: number, r: number)
: fp.TailCall<number> =>
    
    (n < r) ? fp.TailCall.done(n) 
    : fp.TailCall.call(() => rb(n-r, r)) ;

console.log(rb(10000001,2).invoke()); // wait, out: 1
~~~


## idea froms / see alsos

`fp.memoize`: 
- [Functional Thinking | nealford.com](https://nealford.com/books/functionalthinking.html)

`fp.Pipe`: 
- [Promise | JavaScript | MDN](https://developer.mozilla.org//docs/Web/JavaScript/Reference/Global_Objects/Promise)

`fp.Stream`: 
- [Enumerables and Streams | The Elixir programming language](https://elixir-lang.org/getting-started/enumerables-and-streams.html)
- [Stream.unfold/2. The Stream module in Elixir is full of… | by Dunya Kirkali | Medium](https://haagwee.medium.com/stream-unfold-2-5c22e5cf1a3d)
- [Scala Unfold | Genuine Blog](https://blog.genuine.com/2020/07/scala-unfold/)
- [What's the difference between LazyList and Stream in Scala? - Stack Overflow](https://stackoverflow.com/questions/60128207/whats-the-difference-between-lazylist-and-stream-in-scala)

`fp.Tailcall`: 
- [Tail Recursion in JAVA 8 | Knoldus Blogs](https://blog.knoldus.com/tail-recursion-in-java-8/)


