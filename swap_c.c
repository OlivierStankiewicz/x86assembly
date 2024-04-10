#include <stdio.h>
int swap(int tab[], unsigned int n, int pos1, int pos2);
int main()
{
	int tab[] = { 1, 2, 3, 4, 5 };
	int n = 5;

	int a = swap(tab, n, 1, 4);
	for (int i = 0; i < n; i++)
		printf("%d ", tab[i]);

	printf("\n");
	printf("returned: %d", a);

	printf("\n");

	a = swap(tab, n, 1, 5);
	for (int i = 0; i < n; i++)
		printf("%d ", tab[i]);

	printf("\n");
	printf("returned: %d", a);


	return 0;
}