#! /bin/env sh

fp ()
(
    
    # _tuple -- x y < <(echo X Y)
    # fielder=",$IFS" _tuple -- x y < <(echo XX, YY)
    _tuple () { IFS="${fielder:-$IFS}" read -r "${@:-x}" ; } &&
    
    iterate () (while IFS="${fielder:-$IFS}" "$@" ; do eval "${iterator:-$f}" ; done) &&
    
    # demos
    Iterators ()
    {
        
        : fmt='%o: %o\n' n=16 fib
        : fmt='%x: %x\n' n=16 fib
        : mapas='"$y"' fmt='%d ' n=16 fib
        
        fib () (_x=0 _y=0 _z=1 iterator='test "$x" -eq "'"${n:-13}"'" && break ; _x="$((x + 1))" _y="$((z))" _z="$((y + z))"' iterate eval 'x="$_x" y="$_y" z="$_z" ; printf '"'${fmt:-%d: %d\\n}'"' '"${mapas:-\"\$x\" \"\$y\"}") ;
        
        fib () (x=0 y=0 z=1 iterator='test "$x" -eq "'"${n:-13}"'" && break ; fielder=",$IFS" _tuple -- x y z < <(echo "$((x + 1)), $((z)), $((y + z))")' iterate eval printf "'${fmt:-%d: %d\\n}'" "${mapas:-\"\$x\" \"\$y\"}") ;
        
        :;
        
        "$@" &&
        
        :;
        
    } &&
    
    
    # seq 2 2 8 | cat -n | f='echo "$x -> $y"' fp each x y
    # echo a,b,c:d,e,f: | fielder=, f='echo "$z ~ $x -> $y"' fp each -d : -- y x z
    each () (while IFS="${fielder:-$IFS}" read -r "${@:-p}" ; do eval "$f" ; done) &&
    
    # seq 7 | acc=3 f='echo $((x + acc))' fp reduce -- x
    # echo a,b,c:d,e,f: | fielder=, acc='' f='echo "$y .. $z .. $x ~ $acc"' fp reduce -d : -- x y z
    # echo a,b,c:d,e,f: | fielder=, acc='' f='echo "$acc: $y .. $z .. $x"' fp reduce -d : -- x y z
    reduce () (while IFS="${fielder:-$IFS}" read -r "${@:-p}" ; do local acc="$(eval "$f")${concater:-${IFS: -1}}" ; done ; echo "$(echo "$acc")") &&
    reducer () (while IFS="${fielder:-$IFS}" read -r "${@:-p}" ; do local acc="${concater:-${IFS: -1}}$(eval "$f")" ; done ; echo "$(echo "$acc")") &&
    
    Reducers ()
    {
        
        fib () (acc= reduce x < <(seq "${n:-13}") )
        
        "$@" &&
        
        :;
    } &&
    
    # seq 2 2 8 | cat -n | f='"$x -> $y"' fp map x y
    # echo a,b,c:d,e,f: | fielder=, f='"$z ~ $x -> $y"' fp map -d : -- y x z
    map () (acc='' f='printf '"'${formatter:-%s}'"' "$acc"'"$f" reduce "$@") &&
    
    # fp formatf "$@"
    # formatter=' _%s' fp formatf $(seq 12)
    # eq: seq 12 | f='printf \ _%s "$x"' fp each x
    formatf () (printf "${formatter:-%s\n}" "$@") &&
    
    # repeater=2 fp repeat AA BBB CCCC
    # ofs='!?::' repeater=5 fp repeat AA BBB CCCC
    # ofs=' ' concater=$'\n:;;:' repeater=3 repeat AA BBB CCCC
    repeat () (formatf "$@" | f='"'"$(echo $(concater="${ofs:-$concater}" f='"\$str"' map _ < <(seq "${repeater:-3}") ) )"'"' map str) &&
    
    "$@" &&
    
    : ) &&


: \
fp "$@"
