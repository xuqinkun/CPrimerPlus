#include <stdio.h>

#define MAXTITL 40
#define MAXAUTH 50

struct book {
    char title[MAXTITL];
    char author[MAXAUTH];
    float value;
};

int main()
{
    struct book gift= {.value = 18.90,
        .author = "Philionna Pestle",
        0.25};
    printf("title=%s\n", gift.title);
    printf("author=%s\n", gift.author);
    printf("value=%f\n", gift.value);
    return 0; 
}