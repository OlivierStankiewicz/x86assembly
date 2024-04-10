#include <stdio.h>
__int64 sum(unsigned int n, ...);
int main()
{
	__int64 suma = sum(5, 1000000000000LL, 2LL, 3LL, 4LL, 5LL);  // 1000000000014
	printf("\nSuma tych liczb wynosi: %I64d\n", suma);
	suma = sum(0);                                       // 0
	printf("\nSuma tych liczb wynosi: %I64d\n", suma);
	suma = sum(1, -3LL);                                 // -3
	printf("\nSuma tych liczb wynosi: %I64d\n", suma);
	suma = sum(3, -3LL, -2LL, -1LL);
	printf("\nSuma tych liczb wynosi: %I64d\n", suma);	 // -6

	return 0;
}