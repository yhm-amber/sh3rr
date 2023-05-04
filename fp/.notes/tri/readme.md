[fib.wiki/zh]: https://zh.wikipedia.org/wiki/%E6%96%90%E6%B3%A2%E9%82%A3%E5%A5%91%E6%95%B0
[fib.wiki/en]: https://en.wikipedia.org/wiki/Fibonacci_sequence
[fib.wiki/fr]: https://fr.wikipedia.org/wiki/Suite_de_Fibonacci
[fib.wiki/simple]: https://simple.wikipedia.org/wiki/Fibonacci_number


# Tail recursion, Reduce, and (lazy) Iterator

尾递归、聚合、与惰性迭代器

## Fibonacci

[⚗][fib.wiki/simple]

### Tail recursion

#### *Elixir*

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

### Reduce

#### *Elixir*

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
    |> (elem 0) ;
end ;

fib.(0) |> Enum.reverse # [{0, 0}]
fib.(13) |> Enum.reverse # [ {0, 0}, {1, 1}, {2, 1}, {3, 2}, {4, 3}, {5, 5}, {6, 8}, {7, 13}, {8, 21}, {9, 34}, {10, 55}, {11, 89}, {12, 144}, {13, 233} ]
~~~

### Stream / Lazy list / Iterator

#### *Elixir*

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
    |> Enum.take(n + 1) ;
end ;

fib.(0) # [{0, 0}]
fib.(13) # [ {0, 0}, {1, 1}, {2, 1}, {3, 2}, {4, 3}, {5, 5}, {6, 8}, {7, 13}, {8, 21}, {9, 34}, {10, 55}, {11, 89}, {12, 144}, {13, 233} ]
~~~
