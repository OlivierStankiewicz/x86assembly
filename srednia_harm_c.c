#include <stdio.h>
float srednia_harm(float* tablica, unsigned int n);
int main()
{
	float tabl[] = { 3.3, 4.52, 8.91, 12.56, 81.007, 64.51698, 98423.784326 };
	int n = 7;

	float srednia = srednia_harm(tabl, n);
	printf("%f ", srednia);

	return 0;
}