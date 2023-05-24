# iters.ts

~~~
🐚 a lazy seq and a tco tailcall interface 🦑
~~~

## use

### `Stream`

Just like stream/lazylist in elixir or scala.

#### simple

~~~ ts
const s = Stream.unfold(0, x => x < 10 ? { mapper: x, iter: x + 1 } : undefined ) ;
console.log(s.take(3)); // [0, 1, 2]
~~~

#### fib

~~~ ts
// unfold
const fibs = Stream.unfold
(
    { x: 0, y: 0, z: 1 },
    ({ x, y, z }) => ({ mapper: { x, y }, iter: { x: x + 1, y: z, z: y + z } })
) ;

// or iterate
const fibs = 
Stream
    .iterate({x: 0, y: 0,z: 1}, ({ x, y, z }) => ({ x: x + 1, y: z, z: y + z }))
    .map(({ x, y, z }) => ({ x, y }))
    .filter(({ x, y }) => x % 2 === 1) ;

// use
console.log(fibs.take(3));
console.log(fibs.take(14));
~~~


## idea by

- `Stream`: [Stream.unfold/2. The Stream module in Elixir is full of… | by Dunya Kirkali | Medium](https://haagwee.medium.com/stream-unfold-2-5c22e5cf1a3d)
- `Tailcall`: [Tail Recursion in JAVA 8 - Knoldus Blogs](https://blog.knoldus.com/tail-recursion-in-java-8/)


## see also

- [Scala Unfold | Genuine Blog](https://blog.genuine.com/2020/07/scala-unfold/)
