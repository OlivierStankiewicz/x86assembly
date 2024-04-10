#include <stdio.h>
int dzielenie(int* dzielna, int **dzielnik);

int main()
{
	int a, b;
	int* wsk_b;
	wsk_b = &b;

	printf("\nProsze podac 2 liczby: ");
	scanf_s("%d %d", &a, &b, 32);

	int wynik = dzielenie(&a, &wsk_b);
	printf("%d ", wynik);
	return 0;
}