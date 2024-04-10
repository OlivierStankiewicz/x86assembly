#include <stdio.h>
void przestaw(int tabl[], int n);
int main()
{
	int tabl[] = { 1, 5, 2, 4, 8, 3, 5, 7, 12, 41, 2, 4 };
	int n = 12;

	for (int i = n; i > 1; i--)
		przestaw(tabl, i);
	
	for (int i = 0; i < n; i++)
		printf("%d ", tabl[i]);
	return 0;
}