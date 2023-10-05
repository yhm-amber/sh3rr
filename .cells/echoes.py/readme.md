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

它的关键就在 `type` 函数可以用来创建类，从而支持基于 dictionary 来建立具有相应 attribute 的实例，因为类的 attribute 其实就是基于字典的（即有 [`m.x = 1` 即 `m.__dict__["x"] = 1`](https://docs.python.org/3/reference/datamodel.html?highlight=dictionary#modules) 和 [`C.x` 即 `C.__dict__["x"]`](https://docs.python.org/3/reference/datamodel.html?highlight=dictionary#custom-classes) 这样的语法糖），以及 attribute 的 [`x.f(a)` 即 `C.f(x,a)`](https://docs.python.org/3/reference/datamodel.html#instance-methods) 的特性。
