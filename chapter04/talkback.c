#include <stdio.h>
#include <string.h>

int main()
{
    char name[64];
    printf("What's your name?\n");
    scanf("%s", name);
    printf("Hello, %s. Nice to meet you!\n", name);
    printf("len=%d\n", strlen(name));
    int size = sizeof name;
    printf("%d\n", size);
    return 0;
}