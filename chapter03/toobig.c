#include <stdio.h>

int main()
{
    int i = (1<<31)-1;
    unsigned int j = -1;
    // i=0x7fffffff
    printf("i=%#x\n", i);
    // j=0xffffffff
    printf("j=%#x\n", j);
    // j=4294967295
    printf("j=%u\n", j);

    // i=2147483647 i+1=-2147483648 i+2=-2147483647
    printf("i=%d i+1=%d i+2=%d\n", i, i+1, i+2);
    // i=7fffffff i+1=80000000 i+2=80000001
    printf("i=%x i+1=%x i+2=%x\n", i, i+1, i+2);
    // j=4294967295 j+1=0 j+2=1
    printf("j=%u j+1=%u j+2=%u\n", j, j+1, j+2);
    // j=ffffffff j+1=0 j+2=1
    printf("j=%x j+1=%x j+2=%x\n", j, j+1, j+2);
    return 0;
}
