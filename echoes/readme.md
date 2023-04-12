*“回声”*

----

这是一个高度抽象的依赖关联器，为结构体中的各个属性之间依赖关系的建立提供了一种途径。

定义：

~~~ tsx
const echoes = 
(ffs: {[key: string]: (env: { [key: string]: Function }) => Function})
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
    f1: (env: { [key: string]: Function }) => (n: number) => 1 + n ,
    f2: (env: { [key: string]: Function }) => (n: number) => env.f1(n * 2) ,
} ;

console.log( echoes(ffs).f2(3) ) // 结果为 7
~~~

如果想要不止是函数，也可以把类型里的 `Function` 改为 `any` 。不改也是可以的，因为 `Function` 也包括了 `() => any` 这种情况。
