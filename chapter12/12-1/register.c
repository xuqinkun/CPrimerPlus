#include <stdio.h>
int main()
{
    register int quick = 3;

    // printf("%p\n", &quick); error: address of register variable 'quick' requested
    return 0;
}