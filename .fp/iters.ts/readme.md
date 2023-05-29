# fp.ts

~~~
🦪 lazy seq, memorize, tailrec, pipe, apply, ... 👾
~~~

## use

### `fp.Stream`

Just like stream/lazylist in elixir or scala.

#### simple

~~~ ts
const s = fp.Stream.unfold(0, x => x < 10 ? { mapper: x, iter: x + 1 } : undefined ) ;
console.log(s.take(3)); // [0, 1, 2]
~~~

#### fib

~~~ ts
// unfold
const fibs = fp.Stream.unfold
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

console.log(fibs.take(3));
console.log(fibs.take(14));

console.log(fibs.filter(({ x, y }) => x % 2 === 1).take(3));
console.log(fibs.filter(({ x, y }) => x % 2 === 1).take(14));
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

console.log(factorial(5)); // ans: 120
~~~


#### rem

[ref]: https://segmentfault.com/a/1190000040173495


~~~ ts
const rb = 
(n: number, r: number)
: fp.TailCall<number> =>
    
    (n < r) ? fp.TailCall.done(n) 
    : fp.TailCall.call(() => rb(n-r, r)) ;

console.log(rb(10000001,2).invoke()); // wait, ans: 1
~~~


## idea froms / see alsos

`fp.memoize`: 
- [Functional Thinking | nealford.com](https://nealford.com/books/functionalthinking.html)

`fp.Stream`: 
- [Enumerables and Streams | The Elixir programming language](https://elixir-lang.org/getting-started/enumerables-and-streams.html)
- [Stream.unfold/2. The Stream module in Elixir is full of… | by Dunya Kirkali | Medium](https://haagwee.medium.com/stream-unfold-2-5c22e5cf1a3d)
- [Scala Unfold | Genuine Blog](https://blog.genuine.com/2020/07/scala-unfold/)
- [What's the difference between LazyList and Stream in Scala? - Stack Overflow](https://stackoverflow.com/questions/60128207/whats-the-difference-between-lazylist-and-stream-in-scala)

`fp.Tailcall`: 
- [Tail Recursion in JAVA 8 | Knoldus Blogs](https://blog.knoldus.com/tail-recursion-in-java-8/)


