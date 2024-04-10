#include <stdio.h>
unsigned int check_system_dir(char* directory);

int main()
{
	char nazwa[] = "C:\\WINDOWS\\system32";

	int wynik= check_system_dir(nazwa);
	printf("%d ", wynik);
	return 0;
}