/* strptr.c -- 把字符串看作指针 */
#include <stdio.h>
int main(void)
{
     printf("%p, %p, %c\n", "We", "are", *"space farers");

     char * pt1 = "Something is pointing at me.";
     
    //  pt1[0] = 'a';  导致崩溃    
     printf("%s\n", pt1);
     return 0;
}