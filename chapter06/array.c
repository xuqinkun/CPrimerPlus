#include <stdio.h>

int main(void)
{
    int numbers[10];
    numbers[11] = 1;
    printf("%d\n", numbers[14]);
    return 0;
}