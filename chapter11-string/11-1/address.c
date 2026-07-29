//  addresses.c  -- 字符串的地址
#define MSG "I'm special"

#include <stdio.h>
int main()
{
     char ar[] = MSG;
     char br[] = MSG;
    //  br = ar; error: assignment to expression with array type
     const char *pt = MSG;
     printf("address of \"I'm special\": %p \n", "I'm special");
     printf("              address ar: %p\n", ar);
     printf("              address br: %p\n", br);
     printf("              address pt: %p\n", pt);
     printf("          address of MSG: %p\n", MSG);
     printf("address of \"I'm special\": %p \n", "I'm special");

     return 0;
}