错误自动重试

----

~~~
🦔 tool for retry works on shell
~~~

#### install

Two way:

- copy the context of one `source` file, and write them into `/etc/profile.d/retrier.sh`.
- or change the last line `:;` to `exec retryer "$@"`, then write these context into `~/bin/retryer`.

Then, run `exec $SHELL` to refresh your environment, then it might usable.

#### demo

~~~ sh
ENV='WORKS () { sleep 3 ; cd $RETRIED ; }' retryer WORKS
~~~
