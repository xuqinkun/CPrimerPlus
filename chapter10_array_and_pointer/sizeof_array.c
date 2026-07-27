#include <stdio.h>

int main()
{
    int a[5];
    size_t n = sizeof(a) / sizeof(int);
    printf("n=%u\n", n);
}