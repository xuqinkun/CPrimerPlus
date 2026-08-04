// --- file2.c ---
// int file1_var=10;     multiple definition

#include <stdio.h>
int main()
{
    register int quick = 3;
    printf("file1_var = %d\n", file1_var);
    return 0;
}