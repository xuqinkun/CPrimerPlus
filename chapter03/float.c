#include <stdio.h>
#include <string.h>

int main()
{
    float big = 3.4E38*100.0f;
    printf("%lf\n", big);

    float a,b;
    float x = 2.0e20;
    printf("%f\n",x);
    printf("%x\n",x);
    b = 2.0e20 + 1.0;
    printf("b=%f\n", b);
    a = b - 2.0e20;
    printf("a=%f\n", a);

    // float 不能用 % 取余；直接读其 IEEE 754 的 32 位编码
    unsigned int u;
    memcpy(&u, &x, sizeof(u));
    char bits[33];
    for (int i = 31; i >= 0; i--) {
        bits[31 - i] = ((u >> i) & 1) + '0';
    }
    bits[32] = '\0';
    printf("%s\n", bits);
    // 符号1位 指数8位 尾数23位
    printf("S=%c E=%.8s M=%s\n", bits[0], bits + 1, bits + 9);
    return 0;
}
