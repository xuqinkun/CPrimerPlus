#include <stdio.h>

#define MAXTITL 40
#define MAXAUTH 50

struct book {
    char title;
    int author;
    float value;
};

int main()
{
    struct book dickens, newton;
    printf("dickens=%p\n", &dickens);
    printf("title=%p\n", &dickens.title);
    // printf("%d\n", (&dickens.author) - (&dickens.title));
    printf("author=%p\n", &dickens.author);
    printf("value=%p\n", &dickens.value);

    printf("newton=%p\n", &newton);
    printf("title=%p\n", &newton.title);
    return 0; 
}