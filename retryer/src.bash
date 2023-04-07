#! /bin/env bash

: need bash, or may 'sh: export: illegal option -f'.

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
        
        export -f -- retrying &&
        
        { { eval "$ENV" && "$@" ; } || exec "$SHELL" -c -- "RETRIED=$((RETRIED+1)) retrying $*" ; } &&
        
        1>&2 echo "{ :ok, $RETRIED }" &&
        
        :;
    } &&
    
    eval "$(Generators flags ENV RETRIED RETRIED_TIMES) :" &&
    
    export -- ENV &&
    
    RETRIED="${RETRIED:-${RETRIED_TIMES:-0}}" retrying "$@" &&
    
    :;

) ;
