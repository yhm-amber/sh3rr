#! /bin/env sh


fp ()
(
    
    # Tuple -- x y < <(echo X Y)
    # fielder=",$IFS" Tuple -- x y < <(echo XX, YY)
    Tuple () { IFS="${fielder:-$IFS}" read -r "${@:-x}" ; } &&
    
    # trim $'  \n  U W U \n   \n\n ' $'  \n  U W U \n   \n\n '
    trim () (Tuple -d "${trimmer:=​}" -- s < <(echo "$@" "${trimmer}") && echo "$s") &&
    
    # fp formatf "$@"
    # formatter=' _%s' fp formatf $(seq 12)
    # eq: seq 12 | f='printf \ _%s "$x"' fp per x
    formatf () (printf "${formatter:-%s\n}" "$@") &&
    
    
    iterate () (eval "$past" && while IFS="${fielder:-$IFS}" "$@" ; do eval "${iterator:-$f}" ; done && eval "$future") &&
    
    
    # demos
    Iterators ()
    {
        
        : fmt='%o: %o\n' n=16 fib
        : fmt='%x: %x\n' n=16 fib
        : mapas='"$y"' fmt='%d ' n=16 fib
        
        # use tmp asigns
        fib () 
        (
            _x=0 _y=0 _z=1 \
            iterator='
                
                test "$x" -eq "'"${n:-13}"'" && break ; 
                _x="$((x + 1))" _y="$((z))" _z="$((y + z))"
                
                ' fp iterate \
            eval '
                
                x="$_x" y="$_y" z="$_z" ; 
                printf '"'${fmt:-%d: %d\\n}' ${mapas:-\"\$x\" \"\$y\"}" &&
            
            : ) ;
        
        # or use the Tuple
        fib () 
        (
            x=0 y=0 z=1 \
            iterator='
                
                test "$x" -eq "'"${n:-13}"'" && break ; 
                fielder=",$IFS" Tuple -- x y z < <(echo "$((x + 1)), $((z)), $((y + z))")
                
                ' fp iterate \
            eval printf "'${fmt:-%d: %d\\n}' ${mapas:-\"\$x\" \"\$y\"}" &&
            
            : ) ;
        
        # fmt='%i %i, ' n=13 fib
        # 0 0, 1 1, 2 1, 3 2, 4 3, 5 5, 6 8, 7 13, 8 21, 9 34, 10 55, 11 89, 12 144, 13 233, 
        
        :;
        
        "$@" &&
        
        :;
        
    } &&
    
    
    # seq 2 2 8 | cat -n | f='echo "$x -> $y"' fp per x y
    # echo a,b,c:d,e,f: | fielder=, f='echo "$z ~ $x -> $y"' fp per -d : -- y x z
    
    # per () (while IFS="${fielder:-$IFS}" read -r "${@:-p}" ; do eval "$f" ; done) &&
    per () (iterator="${p:-$f}" iterate read -r "${@:-p}") &&
    
    
    # seq 7 | acc=3 f='echo $((x + acc))' fp reduce -- x
    # echo a,b,c:d,e,f: | fielder=, acc='' f='echo "$y .. $z .. $x ~ $acc"' fp reduce -d : -- x y z
    # echo a,b,c:d,e,f: | fielder=, acc='' f='echo "$acc: $y .. $z .. $x"' fp reduce -d : -- x y z
    
    # reduce () (while IFS="${fielder:-$IFS}" read -r "${@:-p}" ; do local acc="$(eval "$f")${concater:-${IFS: -1}}" ; done ; trim "$acc") &&
    # r_reduce () (while IFS="${fielder:-$IFS}" read -r "${@:-p}" ; do local acc="${concater:-${IFS: -1}}$(eval "$f")" ; done ; trim "$acc") &&
    reduce () (concater="${concater:-${IFS: -1}}" f="$f" acc="${acc}${concater}" p='local acc="$(eval "$f")${concater}"' future='trim "$acc"' per "$@") &&
    rwreduce () (concater="${concater:-${IFS: -1}}" f="$f" acc="${concater}${acc}" p='local acc="${concater}$(eval "$f")"' future='trim "$acc"' per "$@") &&
    
    
    Reducers ()
    {
        
        : fib 16
        : fib -- 2 2 32
        : concater=':: ' fib -- 2 2 32
        : ofs='| ' fib -- 2 2 32
        
        : dont: concater=' ...' fib -- 2 2 32
        : dont: concater=',...' fib -- 2 2 32
        : dont: ofs=': ' concater=':...' fib -- 2 2 32
        
        fib () 
        (
            local ofs="${ofs:-,}" && 
            
            acc="0${ofs} 0${ofs} 1${ofs} _" \
            f='
                echo "$(
                    
                    fielder="${ofs}$IFS" Tuple -d "${concater:-${IFS: -1}}" -- x y z _ < <(echo "$acc") ; 
                    echo "$((x + 1))${ofs} $((z))${ofs} $((y + z))${ofs} ${q}" &&
                    
                    : )${concater:-${IFS: -1}}${acc}"
                
                ' fp reduce q < <(seq "$@") &&
            
            : ) ;
        
        # ofs=' ' fib 13 | f='"$x $y"' fp map -- x y _ _ | tac | f='printf "%s, " "$x $y"' fp per -- x y
        # 0 0, 1 1, 2 1, 3 2, 4 3, 5 5, 6 8, 7 13, 8 21, 9 34, 10 55, 11 89, 12 144, 13 233, 
        
        :;
        
        "$@" &&
        
        :;
    } &&
    
    # seq 2 2 8 | cat -n | f='"$x -> $y"' fp map x y
    # echo a,b,c:d,e,f: | fielder=, f='"$z ~ $x -> $y"' fp map -d : -- y x z
    map () (acc='' f='printf '"'${formatter:-%s}'"' "$acc"'"$f" reduce "$@") &&
    
    
    # repeater=21 fp repeat AA BBB CCCC
    # ofs='!?::' repeater=5 fp repeat AA BBB CCCC
    # ofs=' ' concater=$'\n:;;:' repeater=3 fp repeat AA BBB CCCC
    repeat () (formatf "$@" | f='"'"$(echo $(concater="${ofs:-$concater}" f='"\$str"' map _ < <(seq "${repeater:-3}") ) )"'"' map str) &&
    
    # init='0 0 1' initer='Tuple -- x y z < <(echo "$init") && echo "$x $y $z"' unfolder=' { Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))") && echo "$x $y $z" ; } ' delimiter=' &&' ender=: fp unfold seq 13
    unfold () ("$@" | f="'${unfolder}'" map _ | acc="$initer" concater="${delimiter:-$concater}" f='echo "${acc} ${processes}"' reduce -- processes | init="$init" eval "$(cat -) ${ender:-:}") &&
    
    UnFolders ()
    {
        
        # seq 13 |
        #     
        #     f="'"' { Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))") && echo "$x $y $z" ; } '"'" fp map _ |
        #     acc='Tuple -- x y z < <(echo "$init") && echo "$x $y $z"' f='echo "${acc} ${processes}"' concater=' &&' fp reduce -- processes |
        #     init='0 0 1' eval "$(cat -) :"
        
        : outer='printf "%s, " "$x $y"' n=16 fib
        
        fib ()
        (
            outer="${outer:-echo \"\$x \$y \$z\"}" \
            init='0 0 1' initer='Tuple -- x y z < <(echo "$init") && '"$outer" \
            unfolder=' { Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))") && '"$outer"' ; } ' \
            delimiter=' &&' ender=: \
            fp unfold seq "${n:-13}" &&
            
            : ) ;
        
        # outer='printf "%s, " "$x $y"' n=13 fib
        # 0 0, 1 1, 2 1, 3 2, 4 3, 5 5, 6 8, 7 13, 8 21, 9 34, 10 55, 11 89, 12 144, 13 233, 
        
        :;
        
        "$@" &&
        
        :;
        
    } &&
    
    "$@" &&
    
    : ) &&


: \
fp "$@"
