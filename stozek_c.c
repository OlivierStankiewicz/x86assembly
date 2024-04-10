#include <stdio.h>
float objetosc_stozka(unsigned int big_r, unsigned int small_r, float h);
int main()
{
	float wynik = objetosc_stozka(6, 2, 5.3);	// 288.60765
	printf("%f ", wynik);

	wynik = objetosc_stozka(7, 3, 4.2);	// 347.46015
	printf("%f ", wynik);

	wynik = objetosc_stozka(8, 4, 6.1);	// 715.44537
	printf("%f ", wynik);

	return 0;
}