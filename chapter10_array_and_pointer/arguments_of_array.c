#include <stdio.h>
#define SIZE 5

int sum(int arr[])
{
    printf("arr_addr=%p in sum\n", arr);
    arr[0] = 3;
    return 0;
}

int main()
{
    
    int a[SIZE];
    for (int i = 0; i < SIZE; i++) {
        a[i] = i+1;
    }
    printf("arr_addr=%p in main\n", a);
    sum(a);
    for (int i = 0; i < SIZE; i++) {
        printf("%d\t", a[i]);
    }
    printf("%n");
    return 0;
}
