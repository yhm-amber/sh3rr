
# SHell Pipes TS Reduce | New Bing Askings

## 提要

原本是问 New Bing `|` 和 `|&` 的区别，结果引出了 `<()` 和 `>()` 。

然后我只是对后者和 `tee` 组合着试试，结果发现效果让我联想到前阵子玩儿的 reduce 。确切说是那个我自己写的 `Echoes` 。

然后，我希望看到明确的转换，但是它给错了，但是我又自己给弄出来了。

## 转换

分别有两个使用 `tee` 与 `>()` 的形式，分别形成两个转换效果：

- 一个用于产生汇总的效果（很像 <kbd>[echoes](../../echoes)</kbd> ）
- 一个用于分支管道（也就是复用同样的标准输入）

### 汇总

对于这个逻辑 (SHell) ：

~~~ sh
echo 1,2,3 | 
    
    tee >(awk '{print";::"$0}') | 
    tee >(awk -F, -- '{print"~::"$1}') |
    
    cat ;
~~~

用 Reduce 还原它的效果就是这样 (TypeScript) ：

~~~ typescript
[
    (strs: string[]) => strs.map(str => `;::${str}`) ,
    (strs: string[]) => strs.map(str => `~::${str.split(",")[0]}`) ,
].reduce
(
    (vals: string[], f: (strs: string[]) => string[]) => [... vals, ... f(vals)] ,
    ["1,2,3"]
).forEach(str => console.log(str))
~~~

其结果都是这样的：

~~~~
1,2,3
;::1,2,3
~::1
~::;::1
~~~~

这也更印证了管道和列表加 reduce 的共通性。

### 分支管道

要被模仿的代码 (SHell) ：

~~~ sh
echo 1,2,3 | 
    
    tee >(1>&2 awk '{print";::"$0}') | 
    tee >(1>&2 awk -F, -- '{print"~::"$1}') |
    
    1>&2 cat ;
~~~

这是用 `map` 的模仿 (TypeScript) ：

~~~ typescript
[
    (strs: string[]) => strs.map(str => `;::${str}`) ,
    (strs: string[]) => strs.map(str => `~::${str.split(",")[0]}`) ,
    (strs: string[]) => strs ,
].map(f => Promise.resolve(["1,2,3"]).then(vals => f(vals)))
    .forEach(p => p.then(str => console.log(str)))
~~~

这是用 `reduce` 的模仿 (TypeScript) ：

~~~ typescript
[
    (strs: string[]) => strs.map(str => `;::${str}`) ,
    (strs: string[]) => strs.map(str => `~::${str.split(",")[0]}`) ,
].reduce
(
    (arrps, f) => [ ... arrps, Promise.resolve(arrps[0]).then(arr => f(arr))] ,
    [Promise.resolve(["1,2,3"])]
).forEach(arrp => arrp.then(arr => arr.forEach(str => console.log(str))))
~~~

前一个模仿很直观，后一个一般。但后一个才是真正有一一对应的模仿。

都会有这样的输出（三行顺序不一定）：

~~~~
;::1,2,3
1,2,3
~::1
~~~~

这也很自然地揭示了一个事实： `map` 和 `reduce` 之间是可以等价转换的。确切说，前者是后者的特殊情形封装：

~~~ js
const map = (f, xs) =>
  reduce((acc, x) => acc.concat(f(x)), [], xs)
~~~

参考： <kbd>[you-dont-need/You-Dont-Need-Loops](https://github.com/you-dont-need/You-Dont-Need-Loops#map)</kbd>
