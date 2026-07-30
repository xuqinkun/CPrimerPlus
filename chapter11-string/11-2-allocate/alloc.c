#include <stdio.h>
int main(void)
{
    char *name;
    printf("%p\n%s\n", name, name);
    scanf("%s", name);    // 导致崩溃    
    // printf("%s\n", name);
    return 0;
}