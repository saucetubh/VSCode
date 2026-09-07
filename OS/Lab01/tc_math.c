int tc_add(int a, int b) { return a + b; }

int tc_mul(int a, int b) { return a * b; }

long tc_factorial(int n) {
    long result = 1;
    for (int i = 2; i <= n; i++)
        result *= i;
    return result;
}
