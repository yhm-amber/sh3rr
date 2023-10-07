
x = (
function () 

    a = 1 ;
    b = a + 1 ;
    c = function () return a + b end ;

    return {a=a,c=c} end)
() ;

print (x.a) ; -- > 1
print (x.c()) ; -- > 3
print (x.b) ; -- > nil
