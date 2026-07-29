#include <stdio.h>

int main() {
    // 1. 定义三个长度不同的字符串（在内存中分散存储）
    char str1[] = "Hi";          // 占 3 字节
    char str2[] = "Hello";       // 占 6 字节
    char str3[] = "C Language";  // 占 11 字节

    // 2. 定义指针数组，把它们的地址存起来
    char *ptr_arr[3] = {"Alice", "Bob", "Carol"};

    // 3. 遍历并打印
    for (int i = 0; i < 3; i++) {
        // ptr_arr[i] 取出的是地址，%s 会顺着地址打印整个字符串
        printf("字符串 %d: 指针地址=%p, 字符串内容=%s\n", i, ptr_arr[i], ptr_arr[i]); 
    }
    printf("*ptr_arr = %s\n", *ptr_arr);
    printf("*ptr_arr+6 = %s\n", *ptr_arr+6);
    printf("*ptr_arr+10 = %s\n", *ptr_arr+10);

    return 0;
}