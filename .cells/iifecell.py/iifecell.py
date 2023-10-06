# Python 的 Lambda 可以展现出真正缺乏 let 语法糖支持形态下的 IIFE 。

# 从字典到 x.y 的效果还是需要它来实现
echoes = lambda d: type ('', (), d) () ;

### 这里开始才是 IIFE
### 你会发现 let ... in 的顺序在这里看起来反过来了
### 按照从被依赖到依赖是从下往上的与命令式或 let 语法糖的顺序相反
### 因为外面的会不可避免被写在下面

x = (
(lambda a:
(lambda b:
(lambda c:
    
    echoes(dict(a=a, c=staticmethod(c) ) )

) (c = lambda: a+b)
) (b = a + 1)
) (a = 1) ) ;

x.a ; # ~> 1
x.c() ; # ~> 3
x.b ; # !> object has no attribute 'b'
