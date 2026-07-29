#include <stdio.h>
int main(void)
{
    int a[100] = { [99]=-1};
    for (int i = 0; i < 100; i++)
    {
        printf("a[%d]=%d\n", i, a[i]);
    }


    int b[100] = { 
        [5] = 101, 
        [10] = 101, 
        [11] = 101, 
        [12] = 101, 
        [13] = 101 
    };
    for (int i = 0; i < 100; i++)
    {
        printf("b[%d]=%d\n", i, b[i]);
    }
    return 0;
}