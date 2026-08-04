/* global.c  -- 使用外部变量 */
#include <stdio.h>
int units = 0;         /* 外部变量  */
void critic(void);
int main(void)
{
     printf("units = %p\n", &units);
     int units = 56;
     // extern int units;  /* 可选的重复声明 */
     printf("units = %p\n", &units);
     printf("How many pounds to a firkin of butter?\n");
     // scanf("%d", &units);
     while (units != 56)
          critic();
     printf("You must have looked it up!\n");
     return 0;
}

void critic(void)
{
     /* 删除了可选的重复声明 */
     printf("No luck, my friend. Try again.\n");
     printf("units = %p\n", &units);
     units = 56;
     // scanf("%d", &units);
}