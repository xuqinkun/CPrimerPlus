# 第 3 章 · 数据和 C

> 对应《C Primer Plus》第 3 章。目标：掌握基本数据类型、取值范围、进制、溢出，以及 `printf` / `scanf` 的正确匹配；并结合本仓库示例理解 `const` 的常见误用。

[← 上一章](chapter02.md) · [返回目录](README.md)

---

## 本章学什么

1. 变量的声明、初始化与命名  
2. 整数族（`short` / `int` / `long` / `long long`、有符号与无符号）  
3. 浮点类型与简单键盘输入  
4. 八进制、十六进制字面量与打印  
5. 溢出：有符号 vs 无符号  
6. `printf` 转换说明必须与类型匹配  
7. （扩展）`const` 与指针：只读承诺 vs 强行改写  

本仓库代码目录：[`chapter03/`](../chapter03/)

```bat
run.bat chapter03\platinum.c
run.bat chapter03\base.c -v
run.bat chapter03 --all
```

建议动手顺序：

```text
platinum.c → base.c → integer.c → toobig.c → print2.c
         → local_const.c → global_const.c
         → print.c（选读，可变参数与 UB 示范）
```

---

## 3.1 数据在程序里意味着什么

程序处理的对象主要是：

| 概念 | 含义 |
|------|------|
| 常量 | 字面写死的值，如 `100`、`3.14`、`'A'`、`"hi"` |
| 变量 | 有名字、占内存、运行时可改的对象 |
| 类型 | 决定占多少字节、怎么解释比特、能做哪些运算 |

同一串比特，按不同类型解读结果不同：这是后面「用错 `%d` / `%u`」会出怪数的根本原因。

---

## 3.2 变量：声明、赋值、初始化

### 3.2.1 三步可以合并

```c
int weight;       /* 声明：引入名字与类型；值是不确定的（局部变量） */
weight = 75;      /* 赋值 */

int height = 180; /* 声明 + 初始化（推荐） */
```

局部变量（写在函数里的）若只声明不初始化就拿去用，值是**不确定**的，属于常见 bug。养成习惯：**声明时就初始化**。

### 3.2.2 关键字 `int` 与对象 `weight`

- `int`：类型  
- `weight`：标识符（变量名）  
- `75`：整型常量  

### 3.2.3 命名规则复习

- 字母 / 数字 / `_`，不能以数字开头  
- 区分大小写  
- 不要占用关键字  
- 名字应表意：`weight_lb` 胜过 `w`  

---

## 3.3 整数类型全家桶

### 3.3.1 标准整数类型（逻辑关系）

```text
                 ┌─ signed（有符号，默认）
  整数宽度系列 ──┤
                 └─ unsigned（无符号，≥ 0）

短 → 长（宽度“通常”不减，标准只保证相对关系）：
  short ≤ int ≤ long ≤ long long
```

写法等价举例：

```c
short int erns;
short jobs;          /* 同上省略 int */

long int estine;
long johns;

unsigned int u;
unsigned u2;         /* 省略时默认是 unsigned int */
unsigned short us;
```

参见：[`integer.c`](../chapter03/integer.c)

### 3.3.2 为什么要用 `sizeof`

**标准不规定** `int` 一定是 4 字节（虽然在当代桌面/ Windows MinGW 上常见 4）。可移植地探测：

```c
printf("sizeof(int) = %zu\n", sizeof(int));
printf("sizeof(short) = %zu\n", sizeof(short));
printf("sizeof(long) = %zu\n", sizeof(long));
```

注意：`sizeof` 的结果类型是 `size_t`，打印推荐用 `%zu`（C99）。若编译器较老，也可见到用 `%lu` 并转型的写法（本仓库 `integer.c` 里用了 `%lu`，在常见 Windows 上通常能跑，但更标准的是 `%zu`）。

### 3.3.3 有符号范围（直觉）

以 **32 位 `int`** 为例（仅为常见情况）：

| 类型 | 大约范围 |
|------|----------|
| `signed int` | −2 147 483 648 … 2 147 483 647 |
| `unsigned int` | 0 … 4 294 967 295 |

头文件 `<limits.h>` 提供 `INT_MAX`、`UINT_MAX` 等宏，需要精确边界时查它。

### 3.3.4 给无符号赋负数

[`integer.c`](../chapter03/integer.c)：

```c
unsigned short a = -1;
printf("a = %u\n", a);   /* 常见结果：65535（模 2^16） */
```

规则直觉：在无符号类型里，负数会按模 \(2^{n}\) 转换到合法区间。**不要用“赋值 −1”当技巧除非你很清楚自己在做什么**；教学上用它理解补码与模运算。

---

## 3.4 进制：书写与打印

计算机内部是二进制；人类常用十进制；底层调试常用十六进制。

### 3.4.1 字面量怎么写

| 进制 | 写法 | 例子（都是一百） |
|------|------|------------------|
| 十进制 | 普通数字 | `100` |
| 八进制 | 前导 `0` | `0144` |
| 十六进制 | 前缀 `0x` / `0X` | `0x64` |

陷阱：`010` 是八进制的八，不是十！

### 3.4.2 `printf` 怎么显示

[`base.c`](../chapter03/base.c)：

```c
int x = 100;
printf("dec = %d; octal = %o; hex=%x\n", x, x, x);
printf("dec = %d; octal = %#o; hex=%#x\n", x, x, x);
```

| 转换说明 | 作用 |
|----------|------|
| `%d` | 十进制有符号 |
| `%o` | 八进制无符号外观 |
| `%x` / `%X` | 十六进制，小写/大写字母 |
| `%#o` / `%#x` | 自动加前缀风格（`0` / `0x`） |

同一变量 `x`，只是**打印方式**变了，值没变。

---

## 3.5 溢出：`toobig.c` 精读

文件：[`toobig.c`](../chapter03/toobig.c)

### 3.5.1 准备两个极端值

```c
int i = (1 << 31) - 1;   /* 若 int 为 32 位：0x7FFFFFFF，即 INT_MAX */
unsigned int j = -1;     /* 无符号最大值：全比特 1，即 UINT_MAX */
```

`(1 << 31)` 在有符号 `int` 上本身也涉及危险边缘（左移进入符号位），教学代码在 32 位平台上常见；更稳妥写法是用 `INT_MAX` 或 `0x7fffffff`（并注意类型）。

### 3.5.2 现象对比

| 表达式 | 常见打印现象 | 标准怎么说 |
|--------|--------------|------------|
| `i + 1`（`i` 为有符号最大值） | 常变成很大的负数 | **有符号溢出：未定义行为** |
| `j + 1`（`j` 为无符号最大值） | 变成 `0` | **无符号溢出：按模回绕，行为有定义** |

```c
printf("i=%d i+1=%d i+2=%d\n", i, i + 1, i + 2);
printf("j=%u j+1=%u j+2=%u\n", j, j + 1, j + 2);
```

用十六进制看比特会更直观（见文件中的 `%x` 输出）：最大值加一后，有符号常从 `7fffffff` 变为 `80000000`，无符号从 `ffffffff` 变为 `0`。

### 3.5.3 学习结论

1. 需要“大范围非负且可回绕”的语义时，才考虑无符号。  
2. 日常计数、一般运算优先想清楚是否会超过 `INT_MAX`。  
3. **不要依赖有符号溢出后的“包装成负数”**——优化器可以假设“有符号永不溢出”。

---

## 3.6 浮点类型与 `platinum.c`

### 3.6.1 `float` 与 `double`

| 类型 | 常见精度 | 字面量 |
|------|----------|--------|
| `float` | 单精度（约 6～7 位十进制有效数字） | `3.14f` |
| `double` | 双精度（默认浮点字面量） | `3.14`、`1700.0` |
| `long double` | 扩展精度（平台相关） | `3.14L` |

浮点**不是**实数的精确集合：无法精确表示所有小数（例如很多 `0.1` 的二进制循环）。金额关键业务日后应用整数分、定点数或特殊库；本章先掌握用法。

### 3.6.2 书中经典：`platinum.c`

[`platinum.c`](../chapter03/platinum.c)：

```c
float weight;
float value;

printf("Please enter your weight in pounds; ");
scanf("%f", &weight);                 /* 1) %f 对应 float   2) 要 & */

value = 1700.0 * weight * 14.5833;    /* 1700.0 是 double，计算中会提升 */
printf("Your weight in platinum is worth %.2f\n", value);
```

逐步理解：

1. **提示用户** → 用 `printf`（注意提示末尾不一定立刻 `\n`，便于同一行输入）。  
2. **读入** → `scanf("%f", &weight)`  
   - `%f`：读 `float`  
   - `&weight`：传入**地址**，函数才能改到你的变量  
3. **计算** → 单价 × 磅数 × 单位换算系数（书中给定常量）。  
4. **输出** → `%.2f` 表示小数点后 2 位。

### 3.6.3 `scanf` 速查（本章）

| 变量类型 | `scanf` 转换 | 参数 |
|----------|--------------|------|
| `int` | `%d` | `&n` |
| `float` | `%f` | `&x` |
| `double` | `%lf` | `&y`（注意：`printf` 打 `double` 常用 `%f`） |

`printf` 与 `scanf` 对 `double` 的约定**不完全对称**，这是初学高频坑：

```c
double d;
scanf("%lf", &d);     /* 正确 */
printf("%f\n", d);    /* printf 中用 %f 打印 double */
```

---

## 3.7 `printf` 格式必须匹配：`print2.c`

文件：[`print2.c`](../chapter03/print2.c)

```c
unsigned int un = 3000000000; /* 超过了 32 位有符号正范围时很常见 */
short end = 200;
long big = 65537;
long long verybig = 12345678908642;

printf("un = %u and not %d\n", un, un);
printf("end = %hd and %d\n", end, end);
printf("big = %ld and not %hd\n", big, big);
printf("verybig = %lld and not %ld\n", verybig, verybig);
```

### 3.7.1 为什么 “not %d” 会错

`printf` 根据**格式串**去解释后面的比特。  
你把巨大的 `unsigned` 用 `%d` 打印时，会被当成有符号解释，于是出现负数或怪数——这正是未定义/错误使用格式的典型课堂演示。

### 3.7.2 常用转换说明表

| 说明 | 典型对应类型 |
|------|----------------|
| `%d` / `%i` | `int` |
| `%u` | `unsigned int` |
| `%hd` / `%hu` | `short` / `unsigned short` |
| `%ld` / `%lu` | `long` / `unsigned long` |
| `%lld` / `%llu` | `long long` / `unsigned long long` |
| `%c` | `char`（按字符显示） |
| `%s` | 字符串（`char *`） |
| `%f` / `%e` / `%g` | 浮点（`printf` 里 `float` 会提升为 `double`） |
| `%p` | 指针地址 |
| `%%` | 打印出 `%` |

宽度与精度（扩展用法）：

```c
printf("%5d\n", 42);      /* 至少宽 5，右对齐 */
printf("%.2f\n", 3.14159); /* 小数点后 2 位 */
printf("%8.2f\n", 3.14);   /* 总宽 8，小数 2 位 */
```

### 3.7.3 默认实参提升（理解 `print2` 为何有时“碰巧对”）

调用可变参数函数（如 `printf`）时：

- `float` → 提升为 `double`  
- `char` / `short` → 提升为 `int`（常见情况）  

所以 `printf("%d", (short)end)` 有时看起来也能工作，但**该用 `%hd` 时仍应写清楚**，并对 `long` / `long long` / `unsigned` 绝不可掉以轻心。

---

## 3.8 选读：`print.c` 与可变参数

文件：[`print.c`](../chapter03/print.c)

### 3.8.1 迷你 `my_printf`

核心 API（`<stdarg.h>`）：

| 宏/类型 | 作用 |
|---------|------|
| `va_list` | 参数列表游标 |
| `va_start(ap, last)` | 从最后一个固定参数之后开始 |
| `va_arg(ap, Type)` | 取出下一个参数（按 Type） |
| `va_end(ap)` | 收尾 |

示例逻辑：扫描格式串，遇到 `%d` / `%s` 就取参打印。这是理解「为何格式必须诚实」的最佳直观模型——`printf` **不知道**你真实传了什么类型，只听格式串的。

### 3.8.2 危险调用

```c
printf("%p.%p.%p\n");   /* 三个转换说明，零个参数 → 未定义行为 */
printf("AAAA.%x.%x\n"); /* 同上 */
```

可能“打印出栈上垃圾”，也可能崩溃。永远不要在正式代码里这样写。

---

## 3.9 扩展：`const` 与指针

教科书系统讲指针偏后；本仓库两份示例适合在第 3 章建立正确直觉。

### 3.9.1 `const int` 变量

```c
const int limit = 100;
/* limit = 200; */   /* 编译错误：不能赋值 */
```

`const` 表示**只读对象**（对编译器的承诺；优化器也可能把常量放到只读内存）。

### 3.9.2 `local_const.c`：指针与“通过谁修改”

[`local_const.c`](../chapter03/local_const.c)：

```c
const int *p1;     /* 不能通过 p1 写 *p1；但 p1 可改指向 */
int a = 10, b = 20;
p1 = &a;

int *p2 = (int *)p1;  /* 强制去掉 const 限定（危险） */
*p2 = 30;             /* a 变成 30：因为 a 本身不是 const 对象 */
p1 = &b;
```

记忆口诀（读法从右往左常有帮助）：

| 声明 | 可读作 | 可改指针？ | 可改 `*p`？ |
|------|--------|------------|-------------|
| `const int *p` | 指向 const int 的指针 | 可以 | 不可以 |
| `int * const p` | 指向 int 的 const 指针 | 不可以 | 可以 |
| `const int * const p` | 双 const | 不可以 | 不可以 |

`local_const.c` 能改掉 `a`，是因为 **`a` 不是 const**，只是你“假装”只读访问；通过另一类型的指针写入，绕过了检查。

另外：示例里 `printf("%0x", p1)` 把指针当十六进制整数打，类型也不严格匹配；更合适是 `%p`，并把实参转为 `(void *)p1`。可用 `-Wall` 看到相关警告。

### 3.9.3 `global_const.c`：改真正的常量对象

[`global_const.c`](../chapter03/global_const.c)：

```c
const int GLOBAL_VAL = 100;

int main(void)
{
    int *p = (int *)&GLOBAL_VAL;
    *p = 200;   /* 往往链接/编译能过；运行时常见 ACCESS_VIOLATION / 段错误 */
}
```

原因直觉：全局 `const` 可能被放进**只读数据段**。强制写入 = 写只读内存 → 操作系统杀掉进程。  
对比 `local_const.c`：改的是普通栈上变量 `a`，所以“能改成功”。

**结论：**

- `const` 是类型系统帮忙防错  
- `(Type *)` 强转可以骗过编译器，骗不过操作系统与现实  
- 正确做法：需要改就不要声明成 `const`；需要共享只读数据就保持 `const` 并只通过 `const` 指针访问  

---

## 3.10 字符类型预习（本章边缘）

```c
char ch = 'A';           /* 字符常量，实际是小整数，编码相关 */
printf("%c %d\n", ch, ch);  /* 同值既可当字符又可当整数看 */
```

字符串 `"ABC"` 是尾部带 `\0` 的字符数组，第 4、5、11 章会深入。现在只需：**单引号是字符，双引号是字符串**。

---

## 3.11 `_Bool` 与 `<stdbool.h>`（C99）

```c
#include <stdbool.h>
bool ok = true;
if (ok) { ... }
```

没有该头文件时也可使用 `_Bool`，取值 0 / 1。细节可稍后掌握。

---

## 3.12 类型转换（够本章用的部分）

### 自动（隐式）

```c
int i = 3;
double d = i;      /* int → double */
float f = 1.2f;
double x = f;      /* float → double */
```

表达式中类型会“提升”到更宽/更精确的一侧（详细规则见书中“通常算术转换”）。

### 强制（显式）

```c
int n = (int)3.9;  /* 得到 3，截断，不是四舍五入 */
```

指针相关强制（如去掉 `const`）尤其危险——见上一节。

---

## 3.13 综合错误清单

| 错误 | 后果 |
|------|------|
| `scanf("%f", weight)` 漏 `&` | 轻则警告，重则崩溃/错乱 |
| `printf("%d", ul)` 类型不符 | 错误输出或 UB |
| 有符号溢出当“特性”用 | 优化后行为变化 |
| `010` 当十进制十 | 逻辑错误 |
| 未初始化局部变量 | 间歇性怪值 |
| 强写全局 `const` | 运行时崩溃 |
| `float` 存货币再比较相等 | 精度坑 |

---

## 3.14 本章要点 checklist

- [ ] 能说出至少三种整数类型及打印用的转换说明  
- [ ] 能解释 `unsigned short a = -1` 为何变成很大的数  
- [ ] 能区分有符号溢出（UB）与无符号回绕（有定义）  
- [ ] 能独立重写并运行 `platinum.c`  
- [ ] 看懂 `print2.c` 为何强调 “and not %d”  
- [ ] 能说明 `const int *` 与 `int * const` 的差别  
- [ ] 知道为何 `global_const.c` 可能崩溃而 `local_const.c` 能改 `a`  

---

## 3.15 练习建议

1. 修改 `platinum.c`：改用 `double` + `scanf("%lf", ...)`，比较结果。  
2. 写程序打印本机 `sizeof` 所有基础整数/浮点类型。  
3. 打印 `INT_MAX`、`INT_MAX+1`（观察警告与现象；思考 UB）。  
4. 把 `base.c` 扩展：同时打印二进制……（可用循环自己实现，或查 `printf` 所限）。  
5. 修正 `local_const.c` 的打印格式为 `%p`，再解释输出。  
6. **不要**把 `global_const.c` 当正常功能用；写一段注释解释它为何崩溃。  

---

## 附录 A · 转义字符速查

| 序列 | 含义 |
|------|------|
| `\n` | 换行 |
| `\t` | Tab |
| `\\` | `\` |
| `\"` | `"` |
| `\'` | `'` |
| `\0` | 空字符 |

## 附录 B · 本章示例文件地图

| 文件 | 聚焦 |
|------|------|
| [`platinum.c`](../chapter03/platinum.c) | `float` + `scanf`/`printf` |
| [`base.c`](../chapter03/base.c) | `%d` `%o` `%x` `%#` |
| [`integer.c`](../chapter03/integer.c) | `short`/`long`/`unsigned`/`sizeof` |
| [`toobig.c`](../chapter03/toobig.c) | 溢出对比 |
| [`print2.c`](../chapter03/print2.c) | 格式匹配 |
| [`print.c`](../chapter03/print.c) | 可变参数与错误调用 |
| [`local_const.c`](../chapter03/local_const.c) | `const int *` 与去 const |
| [`global_const.c`](../chapter03/global_const.c) | 改写全局常量对象 |

---

## 参考与导航

- 书籍：《C Primer Plus》第 3 章  
- 代码目录：[`chapter03/`](../chapter03/)  
- 上一章：[`chapter02.md`](chapter02.md)  
- 目录：[`README.md`](README.md)  

[← 上一章](chapter02.md) · [返回目录](README.md)
