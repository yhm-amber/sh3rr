

~~~ rust
fn main() 
{
    
    let b = 
    (|| {
        
        let add = |x: i32, y: i32| -> i32 { x + y };
        let sss = |x: &str, y: &str| -> String { x.to_owned() + y };
        
        struct Cell 
        {
            add: fn(i32, i32) -> i32,
            sss: fn(&str, &str) -> String,
        }
        
        Cell 
        {
            add: add,
            sss: sss,
        }
    })();
    
    println!("{}", (b.add)(1, 2));
    println!("{}", (b.sss)("xx", "yyy"));
}
~~~
