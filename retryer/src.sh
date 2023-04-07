#! /bin/env sh

: no need bash, because of no 'export -f', because use while rather than tailcall exec.

retryer ()
(
    : retryer cmd args ...
    : ENV="some defines or codes generate ..." retryer cmd args ...
    : ENV="make codes in func WORK; all defiles WORK has depends on" retryer WORK
    
    : ENV='WORK () { sleep 3 ; cd $RETRIED ; }' retryer WORK
    
    Generators ()
    (
        lineargs ()
        {
            : lineargs line1 line2 ...
            
            for per in "$@" ;
            do echo "$per" ; done &&
            
            :;
        } &&
        
        flags ()
        {
            : flags ENV RETRIED ...
            
            lineargs "$@" | xargs -i -- echo local '{}="${}"' '&&' &&
            
            :;
        } &&
        
        "$@" &&
        
        :;
    ) &&
    
    
    retrying ()
    {
        : RETRIED=0 retrying cmd args ...
        
        eval "$ENV" && while ! "$@" ; do RETRIED=$((RETRIED+1)) ; done &&
        
        1>&2 echo "{ :ok, $RETRIED }" &&
        
        :;
    } &&
    
    eval "$(Generators flags ENV RETRIED RETRIED_TIMES) :" &&
    
    export -- ENV &&
    
    RETRIED="${RETRIED:-${RETRIED_TIMES:-0}}" retrying "$@" &&
    
    :;

) ;
