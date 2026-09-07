/* Test file: INTENTIONALLY BROKEN, uses a variable that was never
 * declared. `gcc -c tc_bad_undeclared.c` must fail. Do not fix this file. */

int tc_broken_undeclared(void)
{
    total = total + 1;
    return total;
}
