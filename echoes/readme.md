*“回声”*

----

这是一个高度抽象的依赖关联器，为结构体中的各个属性之间依赖关系的建立提供了一种途径。

定义：

~~~ tsx
const echoes = 
(ffs: {[key: string]: (env: { [key: string]: any }) => Function})
: {[key: string]: Function} =>
    Object.entries(ffs).reduce
    (
        (env, [fn, f]) => ({... env, [fn]: f(env)}) ,
        {} as {[key: string]: Function}
    ) ;
~~~

使用：

~~~ tsx
const ffs =
{
    f1: (env: { [key: string]: any }) => (n: number) => 1 + n ,
    f2: (env: { [key: string]: any }) => (n: number) => env.f1(n * 2) ,
} ;

console.log( echoes(ffs).f2(3) ) // 结果为 7
~~~
