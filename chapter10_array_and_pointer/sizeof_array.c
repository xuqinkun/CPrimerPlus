#include <stdio.h>


void size(int a[]) {
    printf("sizeof=%zd\n", sizeof a);
}

int main()
{
    int a[5];
    size_t n = sizeof(a) / sizeof(int);
    printf("n=%zd\n", n);
    size(a);
    return 0;
}