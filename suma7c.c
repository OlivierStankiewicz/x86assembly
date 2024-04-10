#include <stdio.h>
__int64 suma_siedmiu_liczb(__int64 v1, __int64 v2, __int64 v3, __int64 v4, __int64 v5, __int64 v6, __int64 v7);
int main()
{
	__int64 a = 1, b = 12, c = 3, d = 4, e = 4, f = 6, g = 6;
	__int64 suma = suma_siedmiu_liczb(a, b, c, d, e, f, g);
	printf("\nSuma tych 7 liczb wynosi: %I64d\n", a+b+c+d+e+f+g);
	printf("\nSuma tych 7 liczb wynosi: %I64d\n", suma);

	return 0;
}