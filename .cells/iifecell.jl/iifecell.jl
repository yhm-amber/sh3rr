
x = 
( () -> begin 
    
    a = 1 ;
    b = a + 1 ;
    c = () -> a + b ;

(a=a, c=c) end )()

x.a # ~> 1
x.c() # ~> 3
x.b # !> ERROR: type NamedTuple has no field b
