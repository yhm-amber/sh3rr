#! /bin/env sh


Fp ()
{
	
	#. #: Using: ----
	#. Tuple -- x y < <(echo X Y)
	#. FIELDER=",$IFS" Tuple -- x y < <(echo XX, YY)
	Tuple () { IFS="${FIELDER:-${IFS}}" read -r "${@:-x}" && :; } && 
	
	#. #: Using: ----
	#. echo  $'  \n  U W U \n  x \n\n '    $'  x\n  U W U \n   \n\n '
	#. trim  $'  \n  U W U \n  x \n\n '    $'  x\n  U W U \n   \n\n '
	trim () 
	( 
		IFS="${TRIMMER:-${IFS}}" \
			Tuple -d "${ENDER:=​}" -- s < <(echo "$@" "${ENDER}") && 
		echo "$s" && 
		: ) && 
	
	#. #: Using: ----
	#. fp formatf "$@"
	#. FORMATTER=' _%s' fp formatf $(seq 12)
	#. # eq: seq 12 | FN='printf \ _%s "$x"' fp per x
	formatf () ( printf "${FORMATTER:-%s\n}" "$@" && : ) && 
	
	#. #: Using: ----
	#. erro echo xxx
	#. erro fp formatf "$@"
	erro () ( 1>&2 "$@" && : ) && 
	
	iterate () 
	( 
		eval "$PAST" && 
		while IFS="${FIELDER:-$IFS}" "$@" ; 
		do eval "${ITERATOR:-$FN}" ; done && 
		eval "$FUTURE" && 
		: ) && 
	
	
	#: demos
	Iterators ()
	{
		
		: FMT='%o: %o\n' N=16 fib
		: FMT='%x: %x\n' N=16 fib
		: MAP_AS='"$y"' FMT='%d ' N=16 fib
		
		#: use tmp asigns
		fib () 
		( 
			_x=0 _y=0 _z=1 \
			ITERATOR='
				
				test "$x" -eq "'"${N:-13}"'" && break ; 
				_x="$((x + 1))" _y="$((z))" _z="$((y + z))"
				
				' fp iterate \
			eval '
				
				x="$_x" y="$_y" z="$_z" ; 
				printf '"'${FMT:-%d: %d\\n}' ${MAP_AS:-\"\$x\" \"\$y\"}" && 
			
			: ) ;
		
		#: or use the Tuple
		fib () 
		( 
			x=0 y=0 z=1 \
			ITERATOR='
				
				test "$x" -eq "'"${N:-13}"'" && break ; 
				FIELDER=",$IFS" Tuple -- x y z < <(echo "$((x + 1)), $((z)), $((y + z))")
				
				' fp iterate \
			eval printf "'${FMT:-%d: %d\\n}' ${MAP_AS:-\"\$x\" \"\$y\"}" && 
			
			: ) ;
		
		#. #: Using: ----
		#. FMT='%i %i, ' N=13 fib
		#. #> 0 0, 1 1, 2 1, 3 2, 4 3, 5 5, 6 8, 7 13, 8 21, 9 34, 10 55, 11 89, 12 144, 13 233, 
		
		:;
		
		"$@" && 
		
		:;
		
	} && 
	
	#. #: Using: ----
	#. seq 2 2 8 | cat -n | FN='echo "$x -> $y"' fp per x y
	#. echo a,b,c:d,e,f: | FIELDER=, FN='echo "$z ~ $x -> $y"' fp per -d : -- y x z
	#, #: ref: ----
	#, per () ( while IFS="${FIELDER:-$IFS}" read -r "${@:-p}" ; do eval "$FN" ; done && : ) && 
	per () ( ITERATOR="${PER:-$FN}" iterate read -r "${@:-p}" && : ) && 
	
	#. #: Using: ----
	#. seq 7 | ACC=3 FN='echo $((x + ACC))' fp reduce -- x
	#. echo a,b,c:d,e,f: | FIELDER=, ACC='' FN='echo "$y .. $z .. $x ~ $ACC"' fp reduce -d : -- x y z
	#. echo a,b,c:d,e,f: | FIELDER=, ACC='' FN='echo "$ACC: $y .. $z .. $x"' fp reduce -d : -- x y z
	#, #: ref: ----
	#, reduce () 
	#, ( 
	#, 	while IFS="${FIELDER:-$IFS}" read -r "${@:-p}" ; 
	#, 	do local ACC="${PRE_CONCATER:-${IFS: -1}}$(eval "$FN")${CONCATER:-${IFS: -1}}" ; done && 
	#, 	trim "$ACC" && 
	#, 	: ) && 
	reduce () 
	( 
		CONCATER="${CONCATER:-${IFS: -1}}" \
		PRE_CONCATER="${PRE_CONCATER}" \
		ACC="${PRE_CONCATER}${ACC}${CONCATER}" \
		FN="$FN" \
		PER='local ACC="${PRE_CONCATER}$(eval "$FN")${CONCATER}"' \
		FUTURE='trim "$ACC"' \
			per "$@" && 
		: ) && 
	
	
	Reducers ()
	{
		
		: fib 16
		: fib -- 2 2 32
		: CONCATER=':: ' fib -- 2 2 32
		: OFS='| ' fib -- 2 2 32
		
		: dont: CONCATER=' ...' fib -- 2 2 32
		: dont: CONCATER=',...' fib -- 2 2 32
		: dont: OFS=': ' CONCATER=':...' fib -- 2 2 32
		
		fib () 
		(
			local OFS="${OFS:-,}" && 
			
			ACC="0${OFS} 0${OFS} 1${OFS} _" \
			FN='
				echo "$(
					
					FIELDER="${OFS}$IFS" Tuple -d "${CONCATER:-${IFS: -1}}" -- x y z _ < <(echo "$ACC") ; 
					echo "$((x + 1))${OFS} $((z))${OFS} $((y + z))${OFS} ${q}" &&
					
					: )${CONCATER:-${IFS: -1}}${ACC}"
				
				' fp reduce q < <(seq "$@") && 
			
			: ) ;
		
		#. #: Using: ----
		#. OFS=' ' fib 13 | FN='"$x $y"' fp map -- x y _ _ | tac | FN='printf "%s, " "$x $y"' fp per -- x y
		#. #> 0 0, 1 1, 2 1, 3 2, 4 3, 5 5, 6 8, 7 13, 8 21, 9 34, 10 55, 11 89, 12 144, 13 233, 
		
		:;
		
		"$@" && 
		
		:;
	} && 
	
	#. #: Using: ----
	#. seq 2 2 8 | cat -n | FN='"$x -> $y"' fp map x y
	#. echo a,b,c:d,e,f: | FIELDER=, FN='"$z ~ $x -> $y"' fp map -d : -- y x z
	map () (ACC='' FN='printf '"'${FORMATTER:-%s}'"' "$ACC"'"$FN" reduce "$@") && 
	
	#. #: Using: ----
	#. REPEATER=21 fp repeat AA BBB CCCC
	#. OFS='!?::' REPEATER=5 fp repeat AA BBB CCCC
	#. OFS=' ' CONCATER=$'\n:;;:' REPEATER=3 fp repeat AA BBB CCCC
	repeat () (formatf "$@" | FN='"'"$(echo $(CONCATER="${OFS:-$CONCATER}" FN='"\$str"' map _ < <(seq "${REPEATER:-3}") ) )"'"' map str) && 
	
	#. #: Using: ----
	#. N=13 INITOR='0 0 1' \
	#. INIT='Tuple -- x y z < <(echo "$INITOR") && echo "$x $y $z"' \
	#. UNFOLDER=' { Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))") && echo "$x $y $z" ; } ' \
	#. FOLDER='echo "${ACC} ${processes}"' \
	#. DELIMITER=' &&' \
	#. 	fp unfold eval 'eval "$(cat -) :"'
	unfold () (
		seq -- "${N:-13}" | 
			FN="'$UNFOLDER'" map _ | 
			ACC="$INIT" CONCATER="${DELIMITER:-$CONCATER}" FN="${FOLDER:-echo \"\$ACC \$processes\"}" reduce -- processes | 
			INITOR="$INITOR" "$@" && 
		: ) && 
	
	UnFolders ()
	{
		
		#, #: ref: ----
		#, seq 13 | 
		#, 	
		#, 	FN="'"' { Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))") && echo "$x $y $z" ; } '"'" fp map _ | 
		#, 	ACC='Tuple -- x y z < <(echo "$initor") && echo "$x $y $z"' FN='echo "${ACC} ${processes}"' CONCATER=' &&' fp reduce -- processes | 
		#, 	initor='0 0 1' eval "$(cat -) :"
		
		: ECHOER='printf "%s, " "$x $y"' N=16 fib
		
		fib ()
		(
			N="${N}" ECHOER="${ECHOER:-echo \"\$x \$y \$z\"}" \
			INIT='Tuple -- x y z < <(echo "$INITOR") && '"$ECHOER" \
			UNFOLDER=' { Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))") && '"$ECHOER"' ; } ' \
			FOLDER='echo "${ACC} ${processes}"' DELIMITER=' &&' \
			INITOR='0 0 1' \
				fp unfold eval 'eval "$(cat -) :"' && 
			
			: ) ;
		
		#. #: Using: ----
		#. ECHOER='printf "%s, " "$x $y"' N=13 fib
		#. #> 0 0, 1 1, 2 1, 3 2, 4 3, 5 5, 6 8, 7 13, 8 21, 9 34, 10 55, 11 89, 12 144, 13 233, 
		
		
		#: or you wana direct ? then you need a folder by yourself, with your unfolder.
		
		#, #: ref: ----
		#, seq 13 |
		#, 	FN="'"' { Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))") && echo "$x $y $z" ; } '"'" fp map _ |
		#, 	ACC='0 0 1' FN='Tuple -- x y z < <(echo "$ACC") && erro echo "$x $y $z" && eval "$processes"' fp reduce -- processes
		
		fib ()
		(
			N="${N}" echoer='echo "$x $y $z"' INIT='0 0 1' RETURNER="${RETURNER:-$echoer}" \
			UNFOLDER=' { Tuple -- x y z < <(echo "$((x + 1)) $((z)) $((y + z))") && '"$echoer"' ; } ' \
			FOLDER='Tuple -- x y z < <(echo "$ACC") && erro '"$RETURNER"' && eval "$processes"' \
				fp unfold cat - | FN="$RETURNER" fp per -- x y z && 
			
			: ) ;
		
		#. #: Using: ----
		#. RETURNER='printf "%s, " "$x $y"' N=13 fib
		#. #> 0 0, 1 1, 2 1, 3 2, 4 3, 5 5, 6 8, 7 13, 8 21, 9 34, 10 55, 11 89, 12 144, 13 233, 
		
		#: attention: only last one is stdout, other all before it both are stderr.
		
		
		:;
		
		"$@" && 
		
		:;
		
	} && 
	
	"$@" && 
	
	:;
} && 

fp () ( Fp "$@" && : ) && 

: \
fp "$@"
