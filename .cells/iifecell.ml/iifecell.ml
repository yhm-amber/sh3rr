type x = {a: int; c: unit -> int} ;;

let x = 
( fun () -> 

    let a = 1 in
    let b = a + 1 in
    let c = fun () -> a + b in

{a = a; c = c} ) () ;;

x.a ;; (* ~> 1 *)
x.c() ;; (* ~> 3 *)
x.b ;; (* !> This expression has type x There is no field b within type x *)

(* 其实这样就可以 *)

let xx = 

    let a = 1 in
    let b = a + 1 in
    let c = fun () -> a + b in

{a = a; c = c} ;;

xx.a ;;
xx.c() ;;

(* 另外，我发现如果不给变量注明类型，它会向上找到就近的那个相似的 type （比如具有相同字段的 record ），不论这个 type 是什么名称。 *)

