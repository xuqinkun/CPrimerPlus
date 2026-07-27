// sum_arr1.c -- 数组元素之和
// 如果编译器不支持 %zd，用 %u 或 %lu 替换它
#include <stdio.h>
#define SIZE 10


int sum(int *start, int *end)     // 这个数组的大小是？
{
     int i;
     int total = 0;

     printf("start=%p end=%p", start, end);

     return total;
}

int main(void)
{
     int marbles[SIZE] = { 20, 10, 5, 39, 4, 16, 19, 26, 31, 20 };
     long answer;

     answer = sum(marbles, marbles + SIZE);
     
     return 0;
}
