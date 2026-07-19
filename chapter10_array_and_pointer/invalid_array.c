#include <stdio.h>

#define SIZE 5
int main()
{
    int oxen[SIZE] = {1, 2, 3, 4};
    int yaks[SIZE];

    // yaks = oxen; // invalid assignment
    yaks[SIZE] = oxen[SIZE];
    
    // yaks[SIZE] = *oxen;
    // yaks[SIZE] = {5,3,2,8};
    // 数组越界
    printf("%d\n", yaks[SIZE]);
    return 0;
}