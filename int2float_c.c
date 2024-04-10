#include <stdio.h>
void int2float(int* calkowite, float* zmienno_przec);

int main()
{
	int calkowite[2] = { 5, 64 };
	float zmienno_przec[4];

	printf("\nW wersji calkowitej - przed konwersja\n");
	printf("%d %d\n", calkowite[0], calkowite[1]);

	int2float(calkowite, zmienno_przec);

	printf("\nW wersji zmiennoprzecinkowej - po konwersji\n");
	printf("%f %f", zmienno_przec[0], zmienno_przec[1]);
	
	printf("\n");

	return 0;
}