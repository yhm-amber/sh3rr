[l.elixir:docs]: https://elixir-lang.org/getting-started/enumerables-and-streams.html
[l.elixir:play]: https://playground.functional-rewire.com


# Tail recursion, Reduce, and (lazy) Iterator

尾递归、聚合、与惰性迭代器

## Fibonacci

[fib.wiki:simple/wikipedia.org]: https://simple.wikipedia.org/wiki/Fibonacci_number
[fib.wiki:zh/wikipedia.org]: https://zh.wikipedia.org/wiki/%E6%96%90%E6%B3%A2%E9%82%A3%E5%A5%91%E6%95%B0
[fib.wiki:de/wikipedia.org]: https://de.wikipedia.org/wiki/Fibonaccizahl
[fib.wiki:en/wikipedia.org]: https://en.wikipedia.org/wiki/Fibonacci_sequence
[fib.wiki:fr/wikipedia.org]: https://fr.wikipedia.org/wiki/Suite_de_Fibonacci


[wiki 🥗][fib.wiki:simple/wikipedia.org]

### TL;DR

#### *[⚗][l.elixir:play] [Elixir][l.elixir:docs]*

~~~ elixir
# aim: 
# [ {0, 0}, {1, 1}, {2, 1}, {3, 2}, {4, 3}, {5, 5}, {6, 8}, {7, 13}, {8, 21}, {9, 34}, {10, 55}, {11, 89}, {12, 144}, {13, 233} ]

# tail rec
fn n when not(n < 0) ->
    iter = 
    fn
        
        {^n, r, y, _}, _ -> [{n,y} | r] ;
        {x, r, y, z}, i ->
            
            {x + 1, [{x,y} | r], z, y + z} |> i.(i) ;
    end ;
    
    {0, [], 0, 1} |> iter.(iter) ;
end .(13) |> Enum.reverse ;

# reduce
fn n when not(n < 0) ->
    0 .. n
    |> Enum.reduce({[], 0, 1}, fn x, {r, y, z} -> {[{x,y} | r], z, y + z} end)
    |> elem 0 ;
end .(13) |> Enum.reverse ;

# stream / lazylist / iterator
fn n when not(n < 0) ->
    Stream.unfold({0, 0, 1}, fn {x, y, z} -> {{x,y}, {x + 1, z, y + z} } end)
    |> Enum.take n+1 ;
end .(13) ;
~~~

### Tail recursion

#### *[⚗][l.elixir:play] [Elixir][l.elixir:docs]*

~~~ elixir
fib = 
fn n when not(n < 0) ->
    iter = 
    fn
        
        {^n, r, y, _}, _ -> [{n,y} | r] ;
        {x, r, y, z}, i ->
            
            {x + 1, [{x,y} | r], z, y + z} |> i.(i) ;
    end ;
    
    {0, [], 0, 1} |> iter.(iter) ;
end ;

fib.(0) |> Enum.reverse # [{0, 0}]
fib.(13) |> Enum.reverse # [ {0, 0}, {1, 1}, {2, 1}, {3, 2}, {4, 3}, {5, 5}, {6, 8}, {7, 13}, {8, 21}, {9, 34}, {10, 55}, {11, 89}, {12, 144}, {13, 233} ]
~~~

#### *🦠 Lua*

...

#### *🥓 Scala*

...


### Reduce

#### *[⚗][l.elixir:play] [Elixir][l.elixir:docs]*

simple: 

~~~ elixir
0..13 |> Enum.reduce({[], 0, 1}, fn x, {r, y, z} -> {[{x,y} | r], z, y + z} end) |> (elem 0) |> Enum.reverse
# [ {0, 0}, {1, 1}, {2, 1}, {3, 2}, {4, 3}, {5, 5}, {6, 8}, {7, 13}, {8, 21}, {9, 34}, {10, 55}, {11, 89}, {12, 144}, {13, 233} ]
~~~

fun: 

~~~ elixir
fib = 
fn n when not(n < 0) ->
    0 .. n
    |> Enum.reduce({[], 0, 1}, fn x, {r, y, z} -> {[{x,y} | r], z, y + z} end)
    |> elem 0 ;
end ;

fib.(0) |> Enum.reverse # [{0, 0}]
fib.(13) |> Enum.reverse # [ {0, 0}, {1, 1}, {2, 1}, {3, 2}, {4, 3}, {5, 5}, {6, 8}, {7, 13}, {8, 21}, {9, 34}, {10, 55}, {11, 89}, {12, 144}, {13, 233} ]
~~~

#### *🧊 TypeScript*

...

#### *🥓 Scala*

...


### Stream / Lazy list / Iterator

#### *[⚗][l.elixir:play] [Elixir][l.elixir:docs]*

simple: 

~~~ elixir
Stream.unfold({0, 1}, fn {y, z} -> {y, {z, y + z} } end) |> Enum.take(13+1)
# [0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233]

Stream.unfold({0, 0, 1}, fn {x, y, z} -> {{x,y}, {x + 1, z, y + z} } end) |> Enum.take(13+1)
# [ {0, 0}, {1, 1}, {2, 1}, {3, 2}, {4, 3}, {5, 5}, {6, 8}, {7, 13}, {8, 21}, {9, 34}, {10, 55}, {11, 89}, {12, 144}, {13, 233} ]
~~~

fun: 

~~~ elixir
fib = 
fn n when not(n < 0) ->
    Stream.unfold({0, 0, 1}, fn {x, y, z} -> {{x,y}, {x + 1, z, y + z} } end)
    |> Enum.take n+1 ;
end ;

fib.(0) # [{0, 0}]
fib.(13) # [ {0, 0}, {1, 1}, {2, 1}, {3, 2}, {4, 3}, {5, 5}, {6, 8}, {7, 13}, {8, 21}, {9, 34}, {10, 55}, {11, 89}, {12, 144}, {13, 233} ]
~~~

#### *🦀 Rust*

...

#### *🧊 TypeScript*

...

#### *🦠 Lua*

...

#### *🥓 Scala*

...

## Factorial

[fac.wiki:simple/wikipedia.org]: https://simple.wikipedia.org/wiki/Factorial
[fac.wiki:zh/wikipedia.org]: https://zh.wikipedia.org/wiki/%E9%98%B6%E4%B9%98
[fac.wiki:de/wikipedia.org]: https://de.wikipedia.org/wiki/Fakult%C3%A4t_(Mathematik)
[fac.wiki:en/wikipedia.org]: https://en.wikipedia.org/wiki/Factorial
[fac.wiki:fr/wikipedia.org]: https://fr.wikipedia.org/wiki/Factorielle

[wiki 🥗][fac.wiki:simple/wikipedia.org]


