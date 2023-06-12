
[⚗]: https://playground.functional-rewire.com
[Elixir]: https://elixir-lang.org/getting-started/enumerables-and-streams.html

[🥑]: https://www.lua.org/demo.html
[Lua]: https://www.lua.org/pil/11.3.html

[🦀]: https://play.rust-lang.org
[Rust]: https://rust-lang.org

[🧊]: https://typescriptlang.org//play
[TypeScript]: https://typescriptlang.org

[🥓]: https://scastie.scala-lang.org
[Scala]: https://scala-lang.org

# Cell funcs with IIFE

## TL;DR

### *[🧊] [TypeScript]*

~~~ ts

~~~

### *[🦀] [Rust]*

~~~ rust
fn main() 
{
    
    let k = 
    (|| {
        
        let add = |x: i32, y: i32| -> i32 { x + y };
        let sss = |x: &str, y: &str| -> String { x.to_owned() + y };
        let a = 1;
        let b = "booooo";
        let _c = "some thing won't export ...";
        
        struct Cell <'s>
        {
            add: fn(i32, i32) -> i32,
            sss: fn(&str, &str) -> String,
            a: i32,
            b: &'s str,
        }
        
        Cell 
        {
            add: add,
            sss: sss,
            a: a,
            b: b,
        }
    })();
    
    println!("{}", (k.add)(k.a, 2)); // 3
    println!("{}", (k.sss)(k.b, "yyy")); // boooooyyy
}
~~~

### *[🥑] [Lua]*

~~~ lua

~~~

### *[⚗] [Elixir]*

~~~ elixir

~~~

### *[🥓] [Scala]*

~~~ scala

~~~

