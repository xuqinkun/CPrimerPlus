#include <stdio.h>

int sum(const int ar[], int n) /* 函数定义 */
{
    int i;
    int total = 0;

    for( i = 0; i < n; i++) {
        total += ar[i]++;   // error: increment of read-only location
    }
    return total;
}

int main()
{
    int a[5];
    sum(a, 5);
    return 0;
}