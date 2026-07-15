#include <stdio.h>
#include <stdbool.h>
#include <string.h>

int main()
{
     
    printf("Boolean has %zd bytes\n", sizeof(bool));
    printf("Long long has %zd bytes\n", sizeof(long long));
    printf("Long has %zd bytes\n", sizeof(long));
    printf("Int has %zd bytes\n", sizeof(int));
    printf("Short has %zd bytes\n", sizeof(short));
    printf("Char has %zd bytes\n", sizeof(char));
    printf("Float has %zd bytes\n", sizeof(float));
    printf("Double has %zd bytes\n", sizeof(double));
    printf("Long double has %zd bytes\n", sizeof(long double));
    return 0;
}