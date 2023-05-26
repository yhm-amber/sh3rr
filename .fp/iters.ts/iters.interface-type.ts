export 
interface Tailcall
<T> 
{
    (): Tailcall<T> ;
    completed?: boolean ;
    result?: T ;
} ;

export 
const tailcall = 
{
    call: 
        
        <T,>(nextcall: Tailcall<T>)
        : Tailcall<T> => nextcall ,
    
    done: 
    
        <T,>(value: T)
        : Tailcall<T> =>
            
            Object.assign
            (
                () => { throw new Error(":tailcall: not implemented"); } , 
                { completed: true, result: value }
            ) ,
    
    invoke: 
    
        <T,>(tailcall: Tailcall<T>)
        : T =>
            
            Stream.iterate(tailcall, (call) => (call.completed ? call : call()) )
                .takeUntil((call) => call.completed!)
                .reduce((_, call) => call.result!, tailcall.result!) ,
    
} ;
