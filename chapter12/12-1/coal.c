/* coal.c -- 在另一文件中定义外部变量 Coal */
#include <stdio.h>

char Coal = 'X'; /* 外部定义：供其它文件用 extern 声明后使用 */

/* 也可在本文件使用其它文件里定义的外部变量 */
extern int Errupt;
extern double Up[];

void show_shared(void)
{
    printf("[coal.c] Coal = '%c', Errupt = %d, Up[0] = %.2f\n",
           Coal, Errupt, Up[0]);
}
