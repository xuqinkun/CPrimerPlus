#include <stdio.h>

void printMatrix(int (*pt)[3], int rows) {
    printf("pt = %p\n", pt);
    printf("pt + 1 = %p\n", pt + 1);
    printf("*pt = %p\n", *pt);
    printf("*pt + 1 = %p\n", *pt + 1);
    printf("**pt = %d\n", **pt);
    printf("*(*pt + 1) = %d\n", *(*pt + 1));
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d ", *(*(pt+i)+j));
        }
        printf("\n");
    }
}

int main() {
    // 定义一个 2行3列 的二维数组（在内存中是 6 个 int 连续排列）
    int matrix[2][3] = {
        {1, 2, 3},
        {4, 5, 6}
    };

    printf("matrix = %p\n", matrix);
    printf("matrix + 1 = %p\n", matrix + 1);

    // 把二维数组传给函数
    // 此时 matrix 退化为“指向第一行的指针”，刚好匹配 int (*p)[3]
    printMatrix(matrix, 2);


    return 0;
}