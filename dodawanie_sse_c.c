#include <stdio.h>
void dodawanie_SSE(float* a);
int main()
{
	float wyniki[4];
	dodawanie_SSE(wyniki);
	printf("\nWyniki = %f %f %f %f\n",
		wyniki[0], wyniki[1], wyniki[2], wyniki[3]);
	return 0;
}