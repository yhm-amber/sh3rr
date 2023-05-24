
# SHell Pipes TS Reduce | New Bing Askings

## 提要

原本是问 New Bing `|` 和 `|&` 的区别，结果引出了 `<()` 和 `>()` 。

然后我只是对后者和 `tee` 组合着试试，结果发现效果让我联想到前阵子玩儿的 reduce 。确切说是那个我自己写的 `Echoes` 。

然后，我希望看到明确的转换，但是它给错了，但是我又自己给弄出来了。

## 转换

分别有两个使用 `tee` 与 `>()` 的形式，分别形成两个转换效果：

- 一个用于产生汇总的效果（很像 <kbd>[echoes.ts](../../../echoes#echoests)</kbd> ）
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

## *对话记录*

### 释义

我的输入会进入引用块，下面就是 New Bing 的输出。

对于特殊的输出：

- `- Haetaan kohdetta: **...**` 表示正在以 `...` 为关键词进行搜索。
- `- Luodaan vastauksia sinulle…` 表示正在生成答案。
- `Lähde: Keskustelu Bingin kanssa` 表示参考了什么。
- `- ⚠ ...` 表示会话被终止（可能是网络原因）。

*（这个我查了下是芬兰语。这个是当时的界面语言，不知道怎么回事阴差阳错用上了芬兰语，之前我记得选的是法语。哦我知道了，我选错了，这俩在英语里都是 `F` 开头的 ……）*

其余均是来自 GPT 的输出。

### 内容

#### 1/20

> what is diffie-hellman-group1-sha1 ? reply me on 中文

- Haetaan kohdetta: **diffie-hellman-group1-sha1**
- Luodaan vastauksia sinulle…

diffie-hellman-group1-sha1 是一种密钥交换算法，它使用 SHA-1 作为哈希函数，Oakley Group 2 [RFC2409] (1024位 MODP Group)。这种方法必须支持互操作性，因为所有已知的实现目前都支持它³。

您还想了解什么？😊

Lähde: Keskustelu Bingin kanssa, 2023/4/18
- (1) Why is diffie-hellman-group1-sha1 used instead of diffie-hellman?. https://crypto.stackexchange.com/questions/24538/why-is-diffie-hellman-group1-sha1-used-instead-of-diffie-hellman Käytetty 2023/4/18.
- (2) How to enable diffie-hellman-group1-sha1 key exchange on Debian 8.0?. https://unix.stackexchange.com/questions/340844/how-to-enable-diffie-hellman-group1-sha1-key-exchange-on-debian-8-0 Käytetty 2023/4/18.
- (3) diffie-hellman-group1-sha1 key exchange on Ubuntu - Issues. https://unix.stackexchange.com/questions/700479/diffie-hellman-group1-sha1-key-exchange-on-ubuntu-issues Käytetty 2023/4/18.
- (4) windows - Using "KexAlgorithms diffie-hellman-group1-sha1" did not .... https://stackoverflow.com/questions/38770202/using-kexalgorithms-diffie-hellman-group1-sha1-did-not-resolve-no-matching-ke Käytetty 2023/4/18.
- (5) SFTP Client Connection Issues Involving Diffie-Hellman-Group1-SHA1. https://www.jscape.com/blog/what-you-need-to-know-about-diffie-hellman-group1-sha1-vulnerability Käytetty 2023/4/18.

#### 2/20

> 在 SHell 中，管道符除了可以写成 `|` ，还能写成 `|&` 。二者有何区别？

- Haetaan kohdetta: **difference between | and |& in shell**
- Haetaan kohdetta: **difference between | and |& in bash**
- Haetaan kohdetta: **difference between | and |& in bash shell**

在 Shell 中，`|` 和 `|&` 都是管道符。`|` 用于将一个命令的标准输出传递给另一个命令的标准输入。而 `|&` 则不仅将标准输出传递给另一个命令，还将标准错误输出也传递给另一个命令。

您还想了解什么？😊

Lähde: Keskustelu Bingin kanssa, 2023/4/18
- (1) Diffchecker - Compare text online to find the difference between two .... https://www.diffchecker.com/ Käytetty 2023/4/18.
- (2) linux - Path difference between ../ and ./ - Super User. https://superuser.com/questions/54027/path-difference-between-and Käytetty 2023/4/18.
- (3) Stack Overflow - Where Developers Learn, Share, & Build Careers. https://stackoverflow.com/questions/3427872/whats-the-difference-between-and-in-bash Käytetty 2023/4/18.
- (4) shell - Bash/sh - difference between && and ; - Stack Overflow. https://stackoverflow.com/questions/6152659/bash-sh-difference-between-and Käytetty 2023/4/18.
- (5) Difference between Korn Shell and Bash shell - GeeksForGeeks. https://www.geeksforgeeks.org/shell-scripting-difference-between-korn-shell-and-bash-shell/ Käytetty 2023/4/18.
- (6) Difference between sh and bash - GeeksforGeeks. https://www.geeksforgeeks.org/difference-between-sh-and-bash/ Käytetty 2023/4/18.

#### 3/20

> 问你个问题： `|&` 可以在 dash 或 ash 使用吗？

- Haetaan kohdetta: **|& in dash or ash**
- Luodaan vastauksia sinulle…

我无法确定 `|&` 是否可以在 dash 或 ash 中使用。您可以尝试在这些 shell 中使用它，看看是否有效。

Lähde: Keskustelu Bingin kanssa, 2023/4/18
- (1) shell - Show function definition in Ash and Dash - Stack Overflow. https://stackoverflow.com/questions/37574898/show-function-definition-in-ash-and-dash Käytetty 2023/4/18.
- (2) How to check if string contains a substring in dash or ash?. https://unix.stackexchange.com/questions/326257/how-to-check-if-string-contains-a-substring-in-dash-or-ash Käytetty 2023/4/18.
- (3) Why does SIGTERM work to terminate bash but not ash or dash?. https://unix.stackexchange.com/questions/571123/why-does-sigterm-work-to-terminate-bash-but-not-ash-or-dash Käytetty 2023/4/18.

#### 4/20

> 我试了一下， Ash 中会报错 `-ash: syntax error: unexpected "&"` ，但 Bash 中可以正常使用。在 Bash 中，它就像你说的那样。我执行`(1>&2 echo xx) | cat >/dev/null` 可以看到控制台打印 `xx` ，因为它来自标准错误；但执行 `(1>&2 echo xx) |& cat >/dev/null` 就看不到，因为标准错误也被 `|&` 捕获了。其效果类似于在 SHell 中的 `(1>&2 echo xx) 2>&1 | cat >/dev/null` 。非常好。

很高兴您能够成功地在 Bash 中使用 `|&`。您的实验结果表明，`|&` 可以在 Bash 中使用，但不能在 Ash 中使用。您的理解是正确的，`|&` 可以捕获标准错误输出并将其传递给管道中的下一个命令。

您还想了解什么？😊

#### 5/20

> 我i还想知道，除了 `|` 和 `|&` 外，在 SHell 还有什么别的管道符没？

在 Shell 中，除了 `|` 和 `|&` 外，没有其他的管道符。但是，您可以使用其他方法来实现类似的功能，例如使用命令替换和进程替换。

您还想了解什么？😊

#### 6/20

> 命令替换和进程替换分别是什么？

命令替换和进程替换是 Shell 中两种不同的功能。

命令替换允许您在命令行中嵌入一个命令的输出。它通过将命令放在反引号（``）或 `$()` 中来实现。例如，`echo Today is $(date)` 将输出类似于 `Today is Mon Nov 29 14:16:27 PST 2021` 的内容。

进程替换允许您将一个命令的输出作为另一个命令的输入，而不需要使用管道或临时文件。它通过使用 `<()` 或 `>()` 来实现。例如，`diff <(sort file1) <(sort file2)` 将比较两个文件排序后的内容。

您还想了解什么？😊

#### 7/20

> 命令替换 `$()` 是把一个命令的标准输出内容填写在相应位置，然后再当作命令（或其参数）执行。进程替换的 `<()` 看起来是可以把其中命令标准输出的内容存入一个不存在的文件，而这个文件的文件名就是当前这次对该符号的使用，比如 `<(sort file1)` 就会成为 `sort file1` 的执行结果的一个临时的文件名。这个理解对吗？至于 `>()` ，我还不知道可以怎么用它，对不起。

您对命令替换 `$()` 的理解是正确的。它会将命令的标准输出内容替换到相应的位置，然后再执行命令。

您对进程替换 `<()` 的理解也是正确的。它会创建一个临时文件，其中包含命令的标准输出内容，并将该临时文件的文件名替换到相应的位置。

至于 `>()`，它与 `<()` 类似，但用于将一个命令的标准输入重定向到另一个命令的标准输出。例如，`cat <(echo "Hello World")` 将输出 `Hello World`。

您还想了解什么？😊

#### 8/20

> 你又给了我一个 `<()` 的例子，很感谢。我想知道 `>()` 的例子会是什么样子。可以给我一个吗？谢谢

当然可以。下面是一个使用 `>()` 的例子：

```sh
# 将 "Hello World" 写入文件
echo "Hello World" > >(tee file.txt)
```

在这个例子中，我们使用 `>()` 将 `echo` 命令的标准输出重定向到 `tee` 命令。`tee` 命令会将其标准输入写入文件 `file.txt`，并将其输出到标准输出。

您还想了解什么？😊

#### 9/20

> 也就是我可以这样用： `echo 1,2,3 | tee >(awk '{print"::"$0}' 1>&2) | tee >(awk -F, -- '{print":::"$1}' 1>&2)` ，这样就可以让一份标准输出进入另外两个管道分支了。相当于一种不需要定义变量就复用同一个值的方案。

是的，您可以使用 `tee` 和进程替换 `>()` 来将一份标准输出分发到多个管道分支。您给出的例子就是一个很好的示范。

您还想了解什么？😊

#### 10/20

> 也就是说， `>()` 和 `<()` 类似，都是起到文件名（IO 接口）的作用，只不过后者对接其内命令的标准输出、前者对接其内命令的标准输入。但都是文件名。

您的理解是正确的。`>()` 和 `<()` 都是进程替换，它们都会创建一个临时文件，该临时文件的文件名将替换到相应的位置。`<()` 会将命令的标准输出重定向到该临时文件，而 `>()` 则会将命令的标准输入重定向到该临时文件。

您还想了解什么？😊

#### 11/20

> 我上面那个使用 `tee` 和 `>()` 的例子，我发现它是一种不阻塞的执行，类似于放后台执行，或者在 TS 里的 Promise 。在 SHell 中，是不等执行完成就可能把命令提示符还给你；在 TS 里的 Promise 则是不等其中命令执行完成就能返回一个 Promise 类型的对象。

您的观察是正确的。在您的例子中，`tee` 命令会将其标准输入复制到多个输出流中。其中一个输出流是标准输出，另一个输出流是进程替换 `>()` 创建的临时文件。由于 `tee` 命令会在后台运行，因此它不会阻塞 Shell 的执行。

您还想了解什么？😊

#### 12/20

> （我认为应该是 `>()` 里的 `awk` 被放入后台执行， `tee` 只是完成了绑定输出的任务 …… 不知道您的理解对还是我的对）。 Anyway ，我上面的示例如果去掉 `1>&2` ，也就是像这样： `echo 1,2,3 | tee >(awk '{print"::"$0}') | tee >(awk -F, -- '{print":::"$1}')` ，此时会发生很有意思的事情，那就是 `1,2,3` 和 `::1,2,3` 都变成了 `awk -F, -- '{print":::"$1}'` 的标准输入，而且 `::1,2,3` 总是被补在 `1,2,3` 之后的下一行。这很像 reduce 不是吗？

您的理解是正确的。在您的示例中，`tee` 命令会将其标准输入复制到多个输出流中。其中一个输出流是标准输出，另一个输出流是进程替换 `>()` 创建的临时文件。由于 `tee` 命令会在后台运行，因此它不会阻塞 Shell 的执行。

在您的新示例中，`tee` 命令会将其标准输入复制到两个进程替换 `>()` 创建的临时文件中。这两个临时文件分别连接到两个 `awk` 命令的标准输入。因此，两个 `awk` 命令都会接收到相同的输入。

您还想了解什么？😊

#### 13/20

> `echo 1,2,3 | tee >(awk '{print"::"$0}') | tee >(awk -F, -- '{print":::"$1}')` 这样的逻辑，如果放在 TS 用 reduce 来实现，要怎么写？

您可以使用 TypeScript 中的 `reduce` 方法来实现类似的逻辑。下面是一个示例：

```ts
const input = "1,2,3";
const result = input.split(",").reduce((acc, cur) => {
  acc.push(`::${cur}`);
  acc.push(`:::${cur}`);
  return acc;
}, [] as string[]);
console.log(result.join("\n"));
```

在这个示例中，我们首先使用 `split` 方法将输入字符串分割为字符串数组。然后，我们使用 `reduce` 方法遍历该数组，并将每个元素转换为两个新元素。最后，我们使用 `join` 方法将结果数组连接为一个字符串，并输出结果。

您还想了解什么？😊

#### 14/20

> TS 里怎么连接两个数组为一个？比如把 `[1]` `[2,3]` 变成 `[1,2,3]`

在 TypeScript 中，您可以使用 `concat` 方法或展开运算符 `...` 来连接两个数组。下面是两个示例：

```ts
// 使用 concat 方法
const arr1 = [1];
const arr2 = [2, 3];
const result1 = arr1.concat(arr2);
console.log(result1); // 输出 [1, 2, 3]

// 使用展开运算符 ...
const result2 = [...arr1, ...arr2];
console.log(result2); // 输出 [1, 2, 3]
```

在第一个示例中，我们使用 `concat` 方法将两个数组连接为一个新数组。在第二个示例中，我们使用展开运算符 `...` 将两个数组的元素展开，并将它们放入一个新数组中。

您还想了解什么？😊

#### 15/20

> 我找到了 reduce 的写法： `[ (strs: string[]) => strs.map(str => `::${str}`) , (strs: string[]) => strs.map(str => `:::${str.split(",")[0]}`) , ].reduce ( (vals, f) => [... vals, ... f(vals)] , ["1,2,3"] )` ，之后可以 `.join("\n")` 取得字符串，也可以通过 `.forEach(str => console.log(str))` 输出

您的写法是正确的。您使用了一个函数数组和 `reduce` 方法来实现类似于管道的逻辑。每个函数都会接收一个字符串数组作为输入，并返回一个新的字符串数组作为输出。`reduce` 方法会将每个函数的输出传递给下一个函数，直到所有函数都执行完毕。

您还想了解什么？😊

#### XX/20

> 我相当于是，把 SHell 的 `awk` 里的逻辑照搬到了一个箭头函数的数组里，而 `tee` 与 `>()` 组合使用带来的效果，在这里通过把 reduce 的第一个参数设为 `(vals, f) => [... vals, ... f(vals)]` 来实现。而作为被复用的最初输入的内容，则位于 reduce 的第二个参数，这个参数用于指定初始值。总的来说，我这里的 reduce 第一个参数，就是 SHell 里 `tee` 和 `>()` 组合使用效果的对应的逻辑。

- ⚠ Näyttää siltä, että sinut on kirjattu ulos. Kirjaudu sisään uudelleen.

