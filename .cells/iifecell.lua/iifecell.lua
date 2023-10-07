
x = 
( function () 

    a = 1 ;
    b = a + 1 ;
    c = function () return a + b end ;

return {a=a,c=c} end ) () ;

print (x.a) ; -- > 1
print (x.c()) ; -- > 3
print (x.b) ; -- > nil

--- 或者其实也可以这样
--- 就是都要用完整名称会费劲一点

xx = {}

xx.a = 1 ;
xx.b = xx.a + 1 ;
xx.c = function () return xx.a + xx.b end ;

print (xx.a) -- > 1
print (xx.b) -- > 2
print (xx.c()) -- > 3
