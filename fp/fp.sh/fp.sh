#! /bin/env sh


fp ()
(
    # 这是高贵的换行符。
    export NLINE=$'\n' &&
    
    # seq 2 2 8 | cat -n | f='echo "$x -> $y"' fp map x y
    # echo a,b,c:d,e,f: | fielder=, f='echo "$z ~ $x -> $y"' fp map -d : -- y x z
    map () (while IFS="${fielder:-$IFS}" read -r "${@:-p}" ;do eval "$f";done) &&
    
    # seq 7 | acc=3 f='echo $((x + acc))' fp reduce -- x
    # echo a,b,c:d,e,f: | fielder=, acc='' f='echo "$y .. $z .. $x ~ $acc"' fp reduce -d : -- x y z
    # echo a,b,c:d,e,f: | fielder=, acc='' f='echo "$acc: $y .. $z .. $x"' fp reduce -d : -- x y z
    reduce () (while IFS="${fielder:-$IFS}" read -r "${@:-p}" ; do local acc="$(eval "$f")${concater:-$NLINE}" ; done ; echo "$(echo "$acc")") &&
    reducer () (while IFS="${fielder:-$IFS}" read -r "${@:-p}" ; do local acc="${concater:-$NLINE}$(eval "$f")" ; done ; echo "$(echo "$acc")") &&
    
    # seq 2 2 8 | cat -n | f='"$x -> $y"' fp rdmap x y
    # echo a,b,c:d,e,f: | fielder=, f='"$z ~ $x -> $y"' fp rdmap -d : -- y x z
    rdmap () (acc='' f='printf '"'${formatter:-%s}'"' "$acc"'"$f" reduce "$@") &&
    
    # fp formatf "$@"
    # formatter=' _%s' fp formatf $(seq 12)
    # eq: seq 12 | f='printf \ _%s "$x"' fp map x
    formatf () (printf "${formatter:-%s\n}" "$@") &&
    
    "$@" &&
    
    : ) &&


: \
fp "$@"
