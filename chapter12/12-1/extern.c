/* extern.c -- 外部变量的定义与声明（跨文件）
 * 编译链接（需同时编译 coal.c）:
 *   gcc -Wall -Wextra -std=c11 -g ^
 *       chapter12\12-1\extern.c chapter12\12-1\coal.c ^
 *       -o build\chapter12\12-1\extern.exe
 * 或在本目录运行: run_extern.bat
 */
#include <stdio.h>

int Errupt;                /* 外部定义的变量 */
double Up[100];            /* 外部定义的数组 */
extern char Coal;          /* Coal 定义在 coal.c，这里只声明 */

void next(void);
void show_shared(void);    /* 定义在 coal.c */

int main(void)
{
    extern int Errupt;     /* 可选的声明（Errupt 已在本文件文件作用域定义） */
    extern double Up[];    /* 可选的声明 */

    Errupt = 1;
    Up[0] = 3.14;
    Coal = 'C';             /* 修改另一文件中定义的外部变量 */

    printf("[extern.c main] Errupt = %d, Up[0] = %.2f, Coal = '%c'\n",
           Errupt, Up[0], Coal);

    next();
    show_shared();

    return 0;
}

void next(void)
{
    /* 同一文件内的函数可直接使用文件作用域的外部变量，无需再写 extern */
    Errupt++;
    Up[0] *= 2.0;
    printf("[extern.c next] Errupt = %d, Up[0] = %.2f, Coal = '%c'\n",
           Errupt, Up[0], Coal);
}
