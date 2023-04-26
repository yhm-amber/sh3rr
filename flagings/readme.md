

# flagings.sh

~~~~
🪁 many very useful functions make your shell works have more elegant (make it more fp-like) 🎊
~~~~

----

## Install

In my way, you can just put this file into your `/etc/profile.d`, that's all done.

Or you can copy the code and use them in your way, **just don't forget to comply with *the license* of this project**.

## Use case

If you're installed it in *my way*, you can run this to import the tools while you want to use them:

~~~ sh
Flagings
~~~

Then, all tools will be usable.

There're some use cases for them.

*All test passed on the `ash` SHell in the AlpineLinux operating system.*

### `raise`

Trans a *line* in to *vertical*.

#### 1. (simple) Basic use case

It makes your args into a %each arg one line* text and you can get this text by its *stdout*.

Such as run:

~~~ sh
raise iroh tauri ⚗elixir duckduckgo qwant vow flower $'Tree\'s leaf' "hoo  oolder" 🥗🥗🥗 smile
~~~

Then it will out:

~~~ text
iroh
tauri
⚗elixir
duckduckgo
qwant
vow
flower
Tree's leaf
hoo  oolder
🥗🥗🥗
smile
~~~

And you can use it like this in your defines (such as *script* or *function* ...):

~~~
raise "$@"
~~~

#### 2. (advance) Give me the first valuable

Sometimes, you only want the first not-empty-value in a list. You can solve your request clearly -- just by call this `raise` command.

~~~ sh
eacher=per raiser='test -n "$per" && { echo "$per" && break ; }' raise "$@"
~~~

The *a list of value* I've told is `"$@"`, and the first value that not empty will be send to the *stdout* of this call.

You can test it by this demo:

~~~ sh
eacher=per raiser='test -n "$per" && { echo "$per" && break ; }' raise '' '' '' "" $'Tree\'s leaf' "hoo  oolder" 🥗🥗🥗 smile
~~~

The out should be:

~~~ text
Tree's leaf
~~~


### `_sign`

This command's behavior just like the `=`.

It will change the environment, so I named it bagin as a `_`.

This is some use cases.

#### 1. (simple) Basic assign

~~~ sh
signer=xyz _sign "$iroh_xyz" "$vow_xyz" "$elixir_xyz" "Tree's leaf"
~~~

It have equal behavior with `xyz="${iroh_xyz:-${vow_xyz:-${elixir_xyz:-Tree's leaf}}}"`.

So ... what's the meaning of the `_sign` command ? Didn't `=` is enough ?

No, it sure didn't.

The most important thing is, while you use the `_sign` instead of `=`, your name of a variable called `xyz` can and must be set by a ***value***.

You can do something like this:

~~~ sh
funnyxyz ()
{
    local "$xyz_name"
    signer="$xyz_name" _sign "$@"
    
    : then do some other things
    : that may be need to use the
    : value of $xyz_name ...
    
} ;

: then use like :
xyz_name=happy_neko funnyxyz "$iroh_xyz" "$vow_xyz" "$elixir_xyz" "Tree's leaf"
~~~

... Still meaning less ? Don't worry, something ***much more fantastic*** shall born.

#### 2. (advance) Likely Tuple Workings

See this:

~~~ sh
fielder=: signer="K V" _sign "cat_name:happyneko"
~~~

This will equal with run `K=cat_name V=happyneko`.

Or this:

~~~ sh
fielder=, signer="Name Type Color" _sign "happyneko,cat,whiteyello"
~~~

This will equal with run `Name=happyneko Type=cat Color=whiteyello`.

Perceived something ?

In some great language like *Erlang* or *Elixir*, you can unwarp a tuple like that:

~~~ elixir
line = {"happyneko", :cat, :whiteyello}
...
{name, type, color} = line

# or
{name, type, color} = {"happyneko", :cat, :whiteyello}
~~~

And also the *Scala*, *ES6* and *Python*:

~~~ python
x, y, z = (1, 2, 3)
~~~

And now, YOU CAN USE THIS FEATURE (LIKELY) IN THE SHELL !!

(... Even no need to use `bash`, `fish` or `zsh` ... I've tested this just on an `ash`, And my functions is only depends on `read` command and *the basic feature of SHell* 🙃)

And the next command will show you a use case of this `_sign` function 😜.

### `take`

A *pure command* again ! (Means it won't change any environment when it be called .)

This function will give you a ability to describe a trans clearly.

Such as:

~~~ sh
fielder=, taker='$_1 | $_4 | $_3' take "illya,iroh,bocchi,ikuyo,kitta,eula"
~~~

Then you will get:

~~~ text
illya | ikuyo | bocchi
~~~

You can also get same stdout by these:

~~~ sh
fielder=, taker='$_1 | $_4 | $_3' take illya,,bocchi,ikuyo,,eula,,,
fielder=: taker='$_1 | $_4 | $_3' take illya::bocchi:ikuyo::eula:::
fielder=_ taker='$_1 | $_5 | $_4' take illya_happy_neko_bocchi_ikuyo__eula_

: both 3 lines have same stdout :
# illya | ikuyo | bocchi
~~~

In the string will be given to `taker`, you need to add one `\` before all the `"` or it will cause some …**unexpected error**.

Like that:

~~~ sh
fielder=, taker='$_1  |  \"$_4\"  |  $_3' take "illya,iroh,bocchi,ikuyo,kitta,eula"

: the stdout will be :
# illya  |  "ikuyo"  |  bocchi
~~~

... And, because of the same reason, you can play some ***injection*** such as give a string `I'm broke in 😈"; $SHELL; echo "Bye ~ 😝` to the `taker`:

~~~ sh
fielder=, taker='I'\''m broke in 😈"; $SHELL; echo "Bye ~ 😝' take "illya,iroh,bocchi,ikuyo,kitta,eula"
~~~

This will actually run commands like this: `echo "I'm broke in 😈"; $SHELL; echo "Bye ~ 😝"`, and the place of `$SHELL` will evaluate as a ***normal command*** ...

Well, you have the auth tu run the `take`, so now, I've let you know that it can cause such chaos situation **Only If You Don't Add A `\` Before All the `"` In The Text You Will Give to the `taker`** .

... I may fix it in future ...
