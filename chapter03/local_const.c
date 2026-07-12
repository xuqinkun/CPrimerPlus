#include <stdio.h>
int main()
{
    const int *p1;
    int a = 10, b = 20;
    p1 = &a;
    printf("%0x p1 = %d\n", p1, *p1);
    int *p2 = (int*)p1;
    *p2 = 30;
    p1 = &b;
    printf("%0x p1 = %d\n", p1, *p1);
    printf("%0x p2 = %d\n", p2, *p2);
}