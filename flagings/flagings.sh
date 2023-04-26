
Flagings ()
{
    
    raise ()
    (
        : raise "$@"
        : eacher=per raiser='test -n "$per" && { echo "$per" && break ; }' raise "$@"
        
        local eacher="${eacher:-each}" &&
        local raiser="${raiser:-echo \"\$$eacher\"}" &&
        
        eval 'for '"$eacher"' in "$@" ; do eval "$raiser" ; done' &&
        
        : ) &&
    
    erro () (1>&2 echo "$@") &&
    lose () { erro "$@" && "${loster:-return}" "${loser:-254}" ; } &&
    
    _sign ()
    {
        : signer=VALNAME _sign $VALNAME $ORVALNAME ORVAL ...
        : FLAGS_OF_READ=' ' signer=VALNAME _sign VAL ORVAL ...
        : fielder=: signer='K V' _sign KEY:VAL OR_OTHER_KVTUPLE ...
        
        test -n "$signer" || loser=14 lose signer Lack ☹ \""$signer"\" || return $? ;
        
        test -z "$eacher" && local eacher=per ;
        test -z "$raiser" && local raiser='test -n "$per" && { echo "$per" && break ; }' ;
        
        local goods="$(eacher="$eacher" raiser="$raiser" raise "$@")" &&
        
        IFS="${fielder:-$IFS}" read ${FLAGS_OF_READ:- -r } -- $signer < <(echo "$goods") &&
        
        :;
        
    } &&
    
    # seq 4 | per=x f='printf \ %s _"$x"' map
    map () (while read -r -- "${per:-p}";do eval "$f";done) &&
    
    take ()
    (
        : fielder=, taker='$_1; $_4; $_3' take illya,,bocchi,ikuyo,kitta,eula,,
        : : 'illya; ikuyo; bocchi'
        
        local fields="$(seq "${fieldlen:-256}" | per=x f='printf \ %s _"$x"' map)" &&
        
        local $fields &&
        fielder="$fielder" signer="$fields" _sign "$@" &&
        
        eval echo \""$taker"\" &&
        : )
    
    "$@" &&
    
    :;
} ;

: \
Flagings "$@" ;
