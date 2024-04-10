#include <stdio.h>

typedef struct _czas {
	unsigned char godzina;
	unsigned char minuty;
} czas;

void daj_czas(czas* cz);

int main()
{
	czas cz;
	daj_czas(&cz);
	printf("Jest godzina: %02d:%02d\n", cz.godzina, cz.minuty);

	return 0;
}