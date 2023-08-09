# fp.ts

~~~
🦪 lazy seq, memoize, tail call optimization , pipe, apply, cell, ... 👾
~~~

## usage

### `fp.memoize`

#### tree rec

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

#### tree rec

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

#### more

~~~ ts
const fibonacci = fp.Stream.iterate([0, 1], ([a, b]) => [b, a + b]).map(([x]) => x) ;
console.log(fibonacci.take(16)); // [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610] 

const fibacc_scan = fibonacci.scan((acc, x) => acc + x) ;
console.log(fibacc_scan.take(10)); // [0, 1, 2, 4, 7, 12, 20, 33, 54, 88]

const fibacc = fibonacci.fold((acc, x) => acc + x, 0) ;
console.log(fibacc.take(11)); // [0, 0, 1, 2, 4, 7, 12, 20, 33, 54, 88]

const fibb = fibonacci.fold((acc, x) => x, 777) ;
console.log(fibb.take(10)); // [777, 0, 1, 1, 2, 3, 5, 8, 13, 21]

const fibh = fibonacci.follow(88).follow(99) ;
console.log(fibh.take(10)); // [99, 88, 0, 1, 1, 2, 3, 5, 8, 13]

const fibw = fibonacci.window(3,2) ;
console.log(fibw.take(5)); // [[0, 1, 1], [1, 2, 3], [3, 5, 8], [8, 13, 21], [21, 34, 55]]

const fibz = fibonacci.zip(fibacc_scan) ;
console.log(fibz.take(7)); // [[0, 0], [1, 1], [1, 2], [2, 4], [3, 7], [5, 12], [8, 20]]
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



## Why

### How borns

最开始是想用 TypeScript 演示一下[这个 TCO 方式](https://blog.knoldus.com/tail-recursion-in-java-8)的，但奈何没有现成的 `Stream` ，所以就又自己基于生成器实现了一个。测试期间发现没有很好用的管道，就也自己做了一个，然后在这个管道的实现里会用得到记忆机制，而这玩意貌似也没有现成的，就又自己实现了一个，顺便把 `apply` 也做了一个因为这样我就可以整一个有记忆的应用器从而可以将记忆机制覆盖到所有即便是已实现了的函数身上。所以我把这整个命名空间就叫 `fp` 了（也算是和[隔壁](../fp.sh)统一了形式 ……）。最后，我把写着玩的回音也整了进来，它允许你的一个模块可以像结构体（ OCaml 里管这个叫记录）一样去用。所以你现在看到了这么个东西。

如果说它的存在意味着什么 …… 那就是你可以很直观地看到 *命令式风格的循环如何可以被用来模拟出函数式风格的调用接口来* 了 —— 而也因此，我并不打算让这些代码变得过于复杂难懂即便这能够增加新的功能。

### Aim

所以，就 *在 TypeScript 上进行 FP* 这一样工作而言，我的库也许并非最好的，因为这并非它的目标。我的目标是体现两种变成风格之间的联系，然后顺手选用了 TypeScript 这么个语言而已因为它刚好符合我的要求（大部分情况下没有 TCO 、有类型系统、对命令式 OOP 风格支持地成熟），仅此而已。

这既不是一个足够好的 FP 库（我相信 [fp-ts](https://gcanti.github.io/fp-ts/) 比我这个更好因为它更具系统的体系 —— 而我这个只求成为一种尽可能小规模的补充），也不是一个足够好的学习资料（除非您已经起码有了解过 Lambda 演算和邱奇数 —— 否则强烈建议从它们开始学习函数式编程）。

足够简洁地体现模拟的逻辑并能够作为原语言本身的一个仅仅关键因而要尽可能简洁的补充（比如我并没有实现自己的 List 因为 TS 本身有数组），这就是我对本仓库赋予的定位。

有了这里的代码，我就可以在其它语言也能做到类似的事情了，比如在 Java 里的 TCO 、在 Rust 里的 Unfold 、在 Lua 里的 Stream ，或者更多语言上的 Memoize （记忆）。

### Why choose Typescript

看起来好像可以有很多别的选择，不过我还是用了 TS 。

为什么用它呢？因为能读懂 JS/TS 的人毕竟还是多一些，而且就算不会前端，会 Java 或者 Scala 的人也能够很容易地识别出 TS 代码的语义来。

为什么不是这些：

- Java: 因为 Java 已经有 Stream 了这样我就没法体现生成器函数（Python, Lua, Rust 应该都有类似的东西）怎么具体可以用来实现 Stream 了。
- Scala: 因为它本身就支持函数式并且标准库也有足够的 HOF 工具。顶多是它还没有 `memoize` ，不过如何在 Scala 实现 `memoize` 也是过于简单的。
- JavaScript: 我认为我起码要在静态类型语言里做到这些事情才行。
- Python: 因为我希望我能有格式化自由。



## ideas from

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


## see also

- [you-dont-need/You-Dont-Need-Loops: Avoid The One-off Problem, Infinite Loops, Statefulness and Hidden intent.](https://github.com/you-dont-need/You-Dont-Need-Loops.git)
- [gcanti/fp-ts: Functional programming in TypeScript](https://github.com/gcanti/fp-ts.git)
- [Common Newbie Mistakes and Bad Practices in Rust: Bad Habits | Michael-F-Bryan](https://adventures.michaelfbryan.com/posts/rust-best-practices/bad-habits)
- [We all know `iter` is faster than `loop`, but why? | The Rust Programming Language Forum](https://users.rust-lang.org/t/we-all-know-iter-is-faster-than-loop-but-why)



