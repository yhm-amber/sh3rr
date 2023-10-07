# Python 的 Lambda 可以展现出真正缺乏 let ... in 语法糖支持的形态下的 IIFE ，因为它功能太少了。

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


### 有一种作弊手段，即海象运算符 (Walrus Operator) 。
### 如果你像下面这样写，会报错。

xx = (

lambda: 
    
    a := 1 ;
    b := a + 1 ;
    c := lambda: a+b ;
    
    echoes(dict(a=a, c=staticmethod(c)))
) () ;

### 上面代码会被警告： cannot use assignment expressions with lambda 。
### 似乎 Python 的闭包真的严格到以至于所有的赋值动作都不被允许。
### 不过，倒是可以假装成元组来实现：

xx = (

lambda: 
(
    a := 1 ,
    b := a + 1 ,
    c := lambda: a+b ,
    
    echoes(dict(a=a, c=staticmethod(c))) ) [-1]

) () ;

xx.a ; # ~> 1
xx.c() ; # ~> 3
xx.b ; # !> object has no attribute 'b'

### 这么看来，它还是并不那么地严谨。

