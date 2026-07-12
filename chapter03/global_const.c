const int GLOBAL_VAL = 100;
int main() {
    int *p = (int *)&GLOBAL_VAL;
    *p = 200; // 编译通过，但运行时直接崩溃（段错误 Segmentation Fault）
}