#include <stdio.h>
float find_max_range(float v, int alpha);
int main()
{
    float  wynik = find_max_range(15.2f, 45);
    printf("wynik: %f\n", wynik);

    wynik = find_max_range(20.0f, 30);
    printf("wynik: %f\n", wynik);

    wynik = find_max_range(20.0f, 80);
    printf("wynik: %f\n", wynik);

	return 0;
}