
x = 
( () -> 
begin 
    a = 1 ;
    b = a + 1 ;
    c = (x) -> a + b - x ;
    (a=a, c=c) 
end )() ;

x.c(0) # ~> 3
x.a # ~> 1
x.b # !> ERROR: type NamedTuple has no field b
