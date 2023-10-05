这个更简单。

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
