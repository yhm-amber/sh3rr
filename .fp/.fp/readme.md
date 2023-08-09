# Pure Function Valuable !!

只要乖乖测好了写，那么用 pure function 就能保证再复杂的东西也不会出错。你甚至不需要看懂代码，你只需要在文档注释写下一个 pure function 应该怎样工作的例子，然后看着例子实现它并测试通过，然后用的时候看着例子用就是了。

要增加新的典型案例也可以，尽量不要改变原来的例子的形式，除非你不介意且能够把该函数的所有已有的调用的形式都照着改一遍。然后改动或者不改动你的这个 pure function 实现确保它支持新的样例。然后，你的工作就完成了。

遵循这些，也能够催使你的实现方式是足够模块化的，因为这样一来，增加新的典型案例的时候，必要的改动就会越小。如果你对这个 pure function 的各个部分的划分和组织做得足够好，一般而言高度的抽象就能做到足够好，那么你会发现，（增加新需求从而不得不增加新样例从而须要）增加符合新样例的功能时，也不会太过麻烦。（新需求是总会诞生的，毕竟「任何一个瞬间都有可能有一个从未有过的结构新生（而这样的场域特性导致即便新生结构大都短暂也无法避免其中足以总能发生场域整个自身加一起都绝对无法成功预料到的意外）」，而上面恰好就是一个能够（基本上）适应于这种「绝对新生」的环境的工作方式。）

这就是函数式编程 (FP) 的好处。

所以，即便在 JS, SHell 这种最初设计为命令式的语言中，我们也大可以不是让循环到处裸奔，而是把它封装为 Fold 或者 Reduce ，或者如果支持生成器定义的话，循环也可以封装为 Unfold 或 Iterate 。这是为了给能够做到上面那样的事创造条件。

当然，这还只是纯函数 (Pure Function) 所带来的启示。如果再多走一步，了解一下 Lambda 演算，你会发现一种截然不同的计算世界的构造：不是机械地右原子堆叠出复杂事物，而是不同结构的、可展开但还没有展开的、那一个一个一个**结构**（事实上这就是函数一次的真正含义），才是符号脱光了站在你眼前的真正样子；而一个符号之为这个符号，是由于它与其它符号按照特定顺序应用时能够产生特定的展开结果 —— 就像现实事物一样，其本质在其边界之边界而非内部，如此构成的将会是一个「事物互相联系」且「只要孤立看待就会自然而然地失去一切意义」的符号世界。