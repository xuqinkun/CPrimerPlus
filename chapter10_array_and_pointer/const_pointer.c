#include <stdio.h>

int main()
{
    double rates[5] = {88.99, 100.12, 59.45, 183.11, 340.5};
    const double * pd = rates;        // pd指向数组的首元素
    // *pd = 29.89;        // 不允许 assignment of read-only location '*pd'
    // pd[2] = 222.22;     //不允许 assignment of read-only location '*pd+16'
    rates[0] = 99.99;   // 允许，因为rates未被const限定

    // double rates[5] = {88.99, 100.12, 59.45, 183.11, 340.5};
    const double locked[4] = {0.08, 0.075, 0.0725, 0.07};
    const double *pc = rates;    // 有效
    printf("1. %lf\n", *pc);
    pc = locked;                  //有效
    printf("2. %lf\n", *pc);
    pc = &rates[3];               //有效
    printf("3. %lf\n", *pc);


    double * pnc = rates;    // 有效
    pnc = locked;            // 无效
    printf("locked[0]=%lf\n", locked[0]);
    *pnc = 1;    
    printf("*pnc= %lf\n", *pnc);
    printf("locked[0]=%lf\n", locked[0]);
    pnc = &rates[3];         // 有效
    return 0;
}