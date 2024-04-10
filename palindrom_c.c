#include <stdio.h>
int isPalindrom(wchar_t* strng, unsigned int liczba_znakow);
int main()
{
	int wynik = isPalindrom(u"kajak", 5);	
	printf("%d ", wynik);

	wynik = isPalindrom(u"korek", 5);
	printf("%d ", wynik);
	return 0;
}