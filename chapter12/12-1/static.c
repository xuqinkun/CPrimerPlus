/*  fgets2.c  -- 使用 fgets() 和 fputs() */
#include <stdio.h>

int more(int number)
{
     int index;
     static int ct = 0;
     int tmp = ct++;
     if (number <= tmp) {
        return tmp;
     }
     printf("ct=%d\n",ct);
     return more(number) + tmp;
}

int main(void)
{
     int n = 10;     
     int ret = more(n);
     printf("sum(0,%d) = %d\n",n, ret);
     return 0;
}