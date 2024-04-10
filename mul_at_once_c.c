#include <stdio.h>
#include <xmmintrin.h>

__m128 mul_at_once(__m128 one, __m128 two);

int main()
{
	__m128 a;
	__m128 b;

	a.m128_i32[0] = 1;
	a.m128_i32[1] = 2;
	a.m128_i32[2] = 3;
	a.m128_i32[3] = 4;

	b.m128_i32[0] = 5;
	b.m128_i32[1] = 6;
	b.m128_i32[2] = 7;
	b.m128_i32[3] = 8;

	__m128 wynik = mul_at_once(a, b);

	for (int i = 0; i < 4; i++)
	{
		printf("%d ", wynik.m128_i32[i]);
	}

	printf("\n");

	return 0;
}