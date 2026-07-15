#include <stdio.h>

int main(void)
{
    int number = 42;
    printf("|%10d|\n", number);   // 以宽度10右对齐输出整数
    printf("|%-10d|\n", number); // 以宽度10左对齐输出整数，便于区分宽度
    printf("|%10.4f|\n", 3.14159);// 以宽度10、小数点后4位右对齐输出浮点数
    printf("|%-10.2f|\n", 3.14159);// 以宽度10，小数点后2位左对齐输出浮点数    
    return 0;
}