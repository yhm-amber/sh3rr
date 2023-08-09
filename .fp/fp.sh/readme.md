
# fp.sh

~~~ md
😈 Just using basic feature of SHell, and pass the tests on the `ash`. 🥗
~~~

一个仅基于基本 SHell 特性的 Functional Programming 工具集。
在 Alpine Ash SHell 通过测试。

## Why

[ydnl.src/gh]: https://github.com/you-dont-need/You-Dont-Need-Loops.git "Avoid The One-off Problem, Infinite Loops, Statefulness and Hidden intent. // 避免一次性问题、无限循环、状态和隐藏意图。"

> Loops include `for`, `forEach`, `while`, `do`, `for...of` and `for...in`. You might argue that built in array methods such as `map` or `reduce` also uses loops. Well that's true, so we are going to define our own. In real life, you’d use a library or built in array methods, but it's good to start from scratch and understand the principles. The performance won't be great, you ask. Yes I heard you, and please read on for now.
> 
> 循环包括 `for` 、 `forEach` 、 `while` 、 `do` 、 `for...of` 和 `for...in` 。您可能会争辩说，内置数组方法（例如 `map` 或 `reduce` 也使用循环）。嗯，确实如此，所以我们将定义我们自己的。在现实生活中，您会使用库或内置数组方法，但最好从头开始并了解其原理。你可能会问，表演不会很好。是的，我听到了，请现在继续阅读。
> 

> Many developers hate it when there's change of requirements, because they have spent so much time on writing performant and bug-free code. When there's new requirements, you'll have to restructure your code and update your unit tests. Can you move your loops freely in your codebase? probably not, because there must be side effects or mutations. Big loops and nested loops are inevitable sometimes for performance reasons. You could do anything in a loop including uncontrolled side effects and therefore, it often breaks [rule of least power](https://en.wikipedia.org/wiki/Rule_of_least_power). Languages such as Haskell uses [fusion](https://stackoverflow.com/questions/38905369/what-is-fusion-in-haskell) to "merge" iterations. [Wholemeal programming](https://www.quora.com/What-is-wholemeal-programming) is a nice pattern to make code modular and reusable.
> 
> 许多开发人员讨厌需求发生变化，因为他们花了很多时间来编写高性能且无错误的代码。当出现新的需求时，您必须重组代码并更新单元测试。您可以在代码库中自由移动循环吗？可能不会，因为一定有副作用或突变。出于性能原因，大循环和嵌套循环有时是不可避免的。您可以在循环中执行任何操作，包括不受控制的副作用，因此，它通常会违反[最小功率规则](https://en.wikipedia.org/wiki/Rule_of_least_power)。 Haskell 等语言使用[融合](https://stackoverflow.com/questions/38905369/what-is-fusion-in-haskell)来“合并”迭代。[全麦编程](https://www.quora.com/What-is-wholemeal-programming)是一种很好的模式，可以使代码模块化和可重用。
> 

> You can write the most performant code with loops and everything. But is it still performant when there's change of requirements? Is your performant code understandable by other people? Is your code still performant once you've refactored your code? At a larger scale, Manual optimization reduces code reusability, modularity and makes components more complex. Code becomes harder to understand, and harder to test for correctness.
> 
> 您可以使用循环和所有内容编写性能最高的代码。但是当需求发生变化时它仍然具有性能吗？其他人可以理解您的高性能代码吗？重构代码后，您的代码仍然具有性能吗？在更大范围内，手动优化降低了代码的可重用性和模块化程度，并使组件更加复杂。代码变得更难理解，也更难测试正确性。
> 

ref by: 
- [you-dont-need/You-Dont-Need-Loops: Avoid The One-off Problem, Infinite Loops, Statefulness and Hidden intent.][ydnl.src/gh]

## Aim

所以，本项目的用意也是类似的。

> Built in array methods such as `map` or `reduce` also uses loops. Well that's true, so we are going to define our own.
> 
> 内置数组方法（例如 `map` 或 `reduce` 也使用循环）。嗯，确实如此，所以我们将定义我们自己的。
> 

但同时，这里的代码也期望一直保持足够简单。

因为我不打算仅仅让它服务与某个企业的生产使用，我更期望它是作为一种证明而存在。一方面是证明 POSIX SHell 也能做到 *[You Dont Need Loops][ydnl.src/gh]* 中类似的事情（无非是匿名函数是会比较挫但其实该有的也姑且可以有），另一方面，这或许算得上是一次，用更彻底的命令式脚本、来虚拟出貌似函数式的功能调用接口，的尝试。

大部分工具应该都挺有用的，而且看一遍下面的简介应该很容易就会了。

…… 有的用起来可能就不那么舒服。它需要你明白一些 SHell 语言 **(*注意不是指 Linux 环境*)** 的基本知识 (`echo`, `eval`, `exec`, `不同的结尾符`, `只有字符串` 等等) ，并且愿意承担一部分的并不困难但很琐碎的心智负担。我明白这应该算作我的失败

一个有意思的扩展阅读：
- [We all know `iter` is faster than `loop`, but why? | The Rust Programming Language Forum](https://users.rust-lang.org/t/we-all-know-iter-is-faster-than-loop-but-why)

## Funcs

简介

### `Tuple`

~~~ sh
Tuple -- x y < <(echo X Y) # then $x will be "X" and $y will be "Y"
fielder=",$IFS" Tuple -- x y < <(echo 'XX, YY') # then $x will be "XX" and $y will be "YY"
~~~

*Just use it inside these fp tools.*

### `trim`

~~~ sh
fp trim $'  \n  U W U \n   \n\n ' $'  \n  U W U \n   \n\n '
~~~

~~~
U W U



  U W U
~~~


### `formatf`

~~~ sh
formatter=' _%s' fp formatf $(seq 12)
~~~

~~~
 _1 _2 _3 _4 _5 _6 _7 _8 _9 _10 _11 _12
~~~

*equal with :*

~~~ sh
f='printf \ _%s "$x"' fp per x < <(seq 12)
~~~


### `iterate`

~~~ sh
fib () 
(
    : n=13 fib
    
    x=0 y=0 z=1 \
    iterator='
        
        test "$x" -eq "'"${n:-13}"'" && break ; 
        Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))")
        
        ' fp iterate "$@" &&
    
    : ) ;

n=13 fib eval 'printf "%i: %i\n" "$x" "$y"'
~~~

~~~
0: 0
1: 1
2: 1
3: 2
4: 3
5: 5
6: 8
7: 13
8: 21
9: 34
10: 55
11: 89
12: 144
13: 233
~~~

*Also see the Fibonacci in Playings.*

*Many things are warppings on `iterate` ...*

### `per`

~~~ sh
seq 2 2 8 | cat -n | f='echo "$x -> $y"' fp per x y
~~~

~~~
1 -> 2
2 -> 4
3 -> 6
4 -> 8
~~~

~~~ sh
echo a,b,c:d,e,f: | fielder=, f='echo "$z ~ $x -> $y"' fp per -d : -- y x z
~~~

~~~
c ~ b -> a
f ~ e -> d
~~~

### `reduce`

~~~ sh
seq 7 | acc=3 f='echo $((x + acc))' fp reduce -- x # 31
echo a,b,c:d,e,f: | fielder=, acc='' f='echo "$y .. $z .. $x ~ $acc"' fp reduce -d : -- x y z # e .. f .. d ~ b .. c .. a ~
~~~

*Also see the Fibonacci in Playings.*

*The `map` is a func that warpping on `reduce` ...*

### `map`

~~~ sh
seq 2 2 8 | cat -n | f='"$x -> $y"' fp map x y
~~~

~~~
1 -> 2
2 -> 4
3 -> 6
4 -> 8
~~~

~~~ sh
echo a,b,c:d,e,f: | fielder=, f='"$z ~ $x -> $y"' fp map -d : -- y x z
~~~

~~~

c ~ b -> a
f ~ e -> d

~~~


### `repeat`

~~~ sh
repeater=21 fp repeat AA BBB CCCC
~~~

~~~
AA AA AA AA AA AA AA AA AA AA AA AA AA AA AA AA AA AA AA AA AA
BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB BBB
CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC CCCC
~~~

~~~ sh
ofs='!?::' repeater=5 fp repeat AA BBB CCCC
~~~

~~~
!?::AA!?::AA!?::AA!?::AA!?::AA!?::
!?::BBB!?::BBB!?::BBB!?::BBB!?::BBB!?::
!?::CCCC!?::CCCC!?::CCCC!?::CCCC!?::CCCC!?::
~~~

~~~ sh
ofs=' ' concater=$'\n:;;:' repeater=3 fp repeat AA BBB CCCC
~~~

~~~
:;;:AA AA AA
:;;:BBB BBB BBB
:;;:CCCC CCCC CCCC
:;;:
~~~

### `unfold`

~~~ sh
fib ()
(
    : n=13 fib
    
    n="$n" init='Tuple -- x y z < <(echo 0 0 1) && echo "$x $y $z"' \
    unfolder=' { Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))") && echo "$x $y $z" ; } ' \
    delimiter=' &&' fp unfold eval 'eval "$(cat -) :"'
    
    : ) ;

n=13 fib | f='"${x}: ${y}"' fp map -- x y z
~~~

~~~
0: 0
1: 1
2: 1
3: 2
4: 3
5: 5
6: 8
7: 13
8: 21
9: 34
10: 55
11: 89
12: 144
13: 233
~~~


*Also see the Fibonacci in Playings.*

*The `unfold` is a warpping on `map` and `reduce` ...*




## Playings

使用例

### Fibonacci

#### *iterator style*

~~~ sh
# use tmp asigns (more quick ... maybe)
fib () 
(
    _x=0 _y=0 _z=1 \
    iterator='
        
        test "$x" -eq "'"${n:-13}"'" && break ; 
        _x="$((x + 1))" _y="$((z))" _z="$((y + z))"
        
        ' fp iterate \
    eval '
        
        x="$_x" y="$_y" z="$_z" ; 
        printf '"'${fmt:-%d: %d\\n}' ${mapas:-\"\$x\" \"\$y\"}" &&
    
    : ) ;

# or use the Tuple inside the fp (more simple ~)
fib () 
(
    x=0 y=0 z=1 \
    iterator='
        
        test "$x" -eq "'"${n:-13}"'" && break ; 
        fielder=",$IFS" Tuple -- x y z < <(echo "$((x + 1)), $((z)), $((y + z))")
        
        ' fp iterate \
    eval printf "'${fmt:-%d: %d\\n}' ${mapas:-\"\$x\" \"\$y\"}" &&
    
    : ) ;
~~~        

~~~ sh
fmt='%i %i, ' n=13 fib
# 0 0, 1 1, 2 1, 3 2, 4 3, 5 5, 6 8, 7 13, 8 21, 9 34, 10 55, 11 89, 12 144, 13 233, 
~~~

#### *reduce style*

~~~ sh
fib ()
(
    acc="0${ofs:-, }0${ofs:-, }1${ofs:-, }_" \
    f='
        
        echo "$(
            
            fielder="${ofs:-,}$IFS" Tuple -d "${concater:-${IFS: -1}}" -- x y z _ < <(echo "$acc") ;
            echo "$((x + 1))${ofs:-, }$((z))${ofs:-, }$((y + z))${ofs:-, }${q}"
            
            )${concater:-${IFS: -1}}${acc}"
        
        ' fp reduce q < <(seq "$@") &&
    
    : ) ;
~~~

~~~ sh
ofs=' ' fib 13 | f='"$x $y"' fp map -- x y _ _ | tac | f='printf "%s, " "$x $y"' fp per -- x y
# 0 0, 1 1, 2 1, 3 2, 4 3, 5 5, 6 8, 7 13, 8 21, 9 34, 10 55, 11 89, 12 144, 13 233, 
~~~

#### *unfold style*

~~~ sh
: style 1
# codegen then pipe (meta-programming like)

fib ()
(
    n="${n}" echoer="${echoer:-echo \"\$x \$y \$z\"}" \
    init='Tuple -- x y z < <(echo "$initer") && '"$echoer" \
    unfolder=' { Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))") && '"$echoer"' ; } ' \
    folder='echo "${acc} ${processes}"' delimiter=' &&' \
    initer='0 0 1' fp unfold eval 'eval "$(cat -) :"' &&
    
    : ) ;

echoer='printf "%s, " "$x $y"' n=13 fib
# 0 0, 1 1, 2 1, 3 2, 4 3, 5 5, 6 8, 7 13, 8 21, 9 34, 10 55, 11 89, 12 144, 13 233, 

: style 2
# direct run inner the reduce and message to stderr (side effect like)

fib ()
(
    n="${n}" echoer='echo "$x $y $z"' init='0 0 1' returner="${returner:-$echoer}" \
    unfolder=' { Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))") && '"$echoer"' ; } ' \
    folder='Tuple -- x y z < <(echo "$acc") && erro '"$returner"' && eval "$processes"' \
    fp unfold cat - | f="$returner" fp per -- x y z &&
    
    : ) ;

returner='printf "%s, " "$x $y"' n=13 fib
# 0 0, 1 1, 2 1, 3 2, 4 3, 5 5, 6 8, 7 13, 8 21, 9 34, 10 55, 11 89, 12 144, 13 233, 
# --- attention: only last one is stdout, other all before it both are stderr.
~~~





