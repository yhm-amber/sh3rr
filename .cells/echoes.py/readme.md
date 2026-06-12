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

函数 `type` 可以用来创建类，从而支持基于字典 (dict) 来建立具有相应属性 (attribute) 的实例。此处有语法糖：
-	类的属性 (attribute) 其实为字典：
	-	有 `module_name.x = 1` 即 `module_name.__dict__["x"] = 1` - ref: [docs.python.org/3/reference/datamodel.html#modules](https://docs.python.org/3/reference/datamodel.html?highlight=dictionary#modules)
	-	有 `ClassName.x` 即 `ClassName.__dict__["x"]` - ref: [docs.python.org/3/reference/datamodel.html#custom-classes](https://docs.python.org/3/reference/datamodel.html?highlight=dictionary#custom-classes)
-	而依此类所建实例 (instance) 的方法 (method) 亦实为类属性中的函数、其语法糖与 R 语言基本对象系统中的管道 (pipe) 类似：
	-	有 `instance_name.f(a)` 即 `ClassName.f(instance_name, a)` - ref: [docs.python.org/3/reference/datamodel.html#instance-methods](https://docs.python.org/3/reference/datamodel.html#instance-methods)
	-	如 `instance_name |> f(a)` 即为 `instance_name |> f.class_name(a)` 即 `f.class_name(instance_name, a)` 在于 R 中（此 `instance_name` 对象于其 `class` 属性中需有 `'class_name'` 这个标记）


它的关键就在 `type` 函数可以用来创建类，从而支持基于 dictionary 来建立具有相应 attribute 的实例，因为类的 attribute 其实就是基于字典的（即有 [`m.x = 1` 即 `m.__dict__["x"] = 1`](https://docs.python.org/3/reference/datamodel.html?highlight=dictionary#modules) 和 [`C.x` 即 `C.__dict__["x"]`](https://docs.python.org/3/reference/datamodel.html?highlight=dictionary#custom-classes) 这样的语法糖），以及 attribute 的 [`x.f(a)` 即 `C.f(x,a)`](https://docs.python.org/3/reference/datamodel.html#instance-methods) 的特性。
