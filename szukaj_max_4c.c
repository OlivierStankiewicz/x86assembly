#include <stdio.h>
int szukaj_max(int a, int b, int c, int d);
int main()
{
	int a, b, c, d, wynik;
	printf("\nProsze podac cztery liczby calkowite ze znakiem: ");
	scanf_s("%d %d %d %d", &a, &b, &c, &d, 32);
	wynik = szukaj_max(a, b, c, d);
	printf("\nSpoœród podanych liczb %d, %d, %d, %d, liczba %d jest najwiêksza\n", a, b, c, d, wynik);
	return 0;
}