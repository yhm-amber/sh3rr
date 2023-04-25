## 基本设定

Basic

- `echo` 在本规范相当于其它语言的 `return` 也就是返回
- `return` `exit` 在本规范相当于其它语言的 `throw` 也就是对异常抛出的设定

Stds

- 标准错误是产生日志信息的接口
- 标准输出是用于指定调用的返回的接口
- 一般而言有换行的标准输出被视为 List 或 LazyList 而标准输入则是专门用于接收此种类型的接口

Call

- 对调用的返回值的获取一般要写作 `"$(called ...)"`

Pipe

- 文件名是具名的 IO 接口作用于文件系统而匿名 IO 接口一般作用于内存中某个明确的范围
- 匿名 IO 接口 `>(called ...)` `<(called ...)` 分别用于连接内部调用的标准输入和标准输出
- 管道符 `|` 自动连接左边调用的标准输出与右边调用的标准输入
- 管道符 `|&` 相当于用比如 `2>&1` 使得左侧调用的标准错误汇入标准输出后再用 `|`

## 程序组织

### 包

#### 应用主体

`独立性` `用于分发` `不影响当前环境`

~~~ sh
xxer ()
(
    : ...
    
    "$@"
)
~~~

要求：

- 名称： `*er`
- 副作用： `不能影响调用时的环境`

#### 工具集合

`用于分发` `允许影响当前环境`

~~~ sh
Xxs ()
{
    : ...
    
    "$@" &&
    
    :;
}
~~~

要求：

- 名称： `*s`
- 名称： `首字母大写`
- 副作用： `能够影响调用时的环境`
- 副作用： `能用于将包内工具带入调用时环境` `(类似于 import)`


### 功能

#### 仅用于内容转换

- `对于功能名称` : `全小写` `动词`
- `对于其重要操作项` : `全小写` `功能名称动词人格化 (即 *or *er ...)`

#### 用于影响当前环境

- `对于功能名称` : `全小写` `_*`
