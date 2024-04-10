#include <stdio.h>
void szybki_max(int t_1[], int t_2[], int t_wynik[], int n);

int main()
{
	int val1[8] = { 1, -1, 2, -2, 3, -3, 4, -4 };
	int val2[8] = { -4, -3, -2, -1, 0, 1, 2, 3 };
	int wynik[8];

	szybki_max(val1, val2, wynik, 8);

	printf("\nWyniki = %d %d %d %d %d %d %d %d\n",
		wynik[0], wynik[1], wynik[2], wynik[3], wynik[4], wynik[5], wynik[6], wynik[7]);
	return 0;
}