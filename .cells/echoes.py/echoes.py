echoes = lambda d: type ('', (), d) () ;

####

x = echoes (dict (
  a = lambda s: 1 ,
  b = lambda s: s.a() + 1 ,
  c = lambda s: lambda: s.a() + s.b() ,
)) ; x.c()() # 3
