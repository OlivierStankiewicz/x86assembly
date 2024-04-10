#include <stdio.h>
int iloczyn_skalarny(int tab1[], int tab2[], int n);
int main()
{
	int tab1[] = { -1, 5, -2, 4 };
	int tab2[] = { 2, -2, 2, -2 };
	int n = 4;

	int wynik = iloczyn_skalarny(tab1, tab2, n);
	printf("wynik iloczynu skalarnego: %d ", wynik);

	return 0;
}