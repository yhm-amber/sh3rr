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


### 之前 GPT 和我说或一种作弊手段，即海象运算符 (Walrus Operator) 。
### 它以为这就能够让赋值动作由于是表达式而不是语句所以在 Python 反而被允许用在 Lambda 中，
### 即便它显然是以副作用为主的。如果真是这样 Python 的 Lambda 也就并不是它要达到的那种严格了。
### 但事实上不行。如果你像下面这样写，会报错。

xx = (

lambda: 
    
    a := 1 ;
    b := a + 1 ;
    c := lambda: a+b ;
    
    echoes(dict(a=a, c=staticmethod(c) ) )
) () ;

### 上面就跑不完，因为你会被警告： cannot use assignment expressions with lambda 。
### 即便把分号改成逗号假装成元组也是一样的。
