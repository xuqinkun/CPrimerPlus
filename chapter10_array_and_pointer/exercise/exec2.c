#include <stdio.h>
int main(void)
{
    int *ptr;
    int torf[2][2] = {12, 14, 16};
    ptr = torf[0];

    printf("*ptr=%d\n", *ptr);
    printf("*(ptr+1)=%d\n", *(ptr+1));
    printf("*(ptr+2)=%d\n", *(ptr+2));

    printf("=========   ==========================   ===============\n");
    int fort[2][2] = { {12}, {14,16} };
    ptr = fort[0];

    printf("*ptr=%d\n", *ptr);
    printf("*(ptr+1)=%d\n", *(ptr+1));
    printf("*(ptr+2)=%d\n", *(ptr+2));
    return 0;
}