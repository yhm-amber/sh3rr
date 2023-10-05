这个更简单。

定义就这一行：

~~~ python
echoes = lambda d: type ('', (), d) () ;
~~~

使用：

~~~ python
echoes (dict (

    a = lambda s:

        1 ,
    
    b = lambda s:

        s.a() + 1 ,
    
    c = lambda s:

        lambda: s.a() + s.b() ,
    
)) .c()() # 3
~~~

它的关键就在 `type` 函数支持基于 dictionary 来建立具有相应 attribute 的实例。
