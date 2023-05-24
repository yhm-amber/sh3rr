export 
interface TailCall
<T> 
{
    (): TailCall<T> ;
    isComplete?: boolean ;
    result?: T ;
} ;

export 
const tailcall = 
{
    call: 
        
        <T,>(nextCall: TailCall<T>)
        : TailCall<T> => nextCall ,
    
    done: 

        <T,>(value: T)
        : TailCall<T> =>
            
            Object.assign
            (
                () => { throw new Error(":tailcall: not implemented"); } , 
                { isComplete: true, result: value }
            ) ,

    invoke: 

        <T,>(tailCall: TailCall<T>)
        : T =>
            
            Stream.iterate(tailCall, (call) => (call.isComplete ? call : call()) )
            .takeUntil((call) => call.isComplete!)
            .reduce((_, call) => call.result!, tailCall.result!) ,
    
} ;
