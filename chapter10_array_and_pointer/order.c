/* order.c -- 指针运算中的优先级 */
#include <stdio.h>
int data[2] = { 100, 200 };
int moredata[2] = { 300, 400 };
int main(void)
{
     int * p1, *p2, *p3;

     p1 = p2 = data;
     p3 = moredata;
     //              100      100              300
     printf("  *p1 = %d,   *p2 = %d,     *p3 = %d\n",*p1, *p2, *p3);
     //             100       200              300
     printf("*p1++ = %d, *++p2 = %d, (*p3)++ = %d\n",*p1++, *++p2, (*p3)++);
     //             200       200              301
     printf("  *p1 = %d,   *p2 = %d,     *p3 = %d\n",*p1, *p2, *p3);

     return 0;
}