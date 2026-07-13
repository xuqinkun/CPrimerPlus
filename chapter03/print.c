#include <stdio.h>
#include <stdarg.h>

// 简化版 printf，仅支持 %d 和 %s
void my_printf(const char *format, ...) {
    va_list args;
    // 1. 初始化，args 指向 format 之后的第一个可变参数
    va_start(args, format);

    for (const char *p = format; *p != '\0'; p++) {
        if (*p == '%') {
            p++; // 跳过 '%'
            if (*p == 'd') {
                // 2. 按 int 类型从栈中取出参数，args 自动向后偏移
                int val = va_arg(args, int);
                printf("%d", val);
            } else if (*p == 's') {
                // 3. 按 char* 类型从栈中取出参数
                char *str = va_arg(args, char*);
                printf("%s", str);
            }
        } else {
            putchar(*p);
        }
    }
    // 4. 清理指针
    va_end(args);
}


int main()
{
    // my_printf("%s %d\n", "aaa", 123);
    printf("%p.%p.%p\n");
    printf("AAAA.%x.%x\n");
}