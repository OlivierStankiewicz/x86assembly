#include <stdio.h>
void przeciwna(int* a);
int main()
{
	int m;
	m = 200;
	przeciwna(&m);
	printf("\n m = %d\n", m);
	return 0;
}