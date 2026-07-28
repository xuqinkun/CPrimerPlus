#include <stdio.h>


void f(int a[4][3]) {
    printf("f:sizeof(a) = %zu\n", sizeof(a));  // 通常是 8（指针），不是 数组的大小
}

int main()
{
    int zippo[4][3]; /* 内含int数组的数组 */
    printf("zippo = %p, zippo + 1 = %p\n", zippo, zippo + 1);
    printf("zippo = %p, zippo[0] = %p\n", zippo, zippo[0]);
    printf("main:sizeof(zippo) = %d, sizeof(zippo[0]) = %d\n", sizeof(zippo), sizeof(zippo[0]));
    printf("zippo + 1=%p, zippo[0] + 1=%p\n", zippo + 1, zippo[0] + 1);

    f(zippo);
    return 0;
}