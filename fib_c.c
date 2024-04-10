#include <stdio.h>
unsigned int fibonacci(unsigned char k);
int main()
{
	unsigned int a;
	a = fibonacci(0);
	printf("%d ", a);
	a = fibonacci(1);
	printf("%d ", a);
	a = fibonacci(2);
	printf("%d ", a);
	a = fibonacci(3);
	printf("%d ", a);
	a = fibonacci(4);
	printf("%d ", a);
	a = fibonacci(5);
	printf("%d ", a);
	a = fibonacci(6);
	printf("%d ", a);
	a = fibonacci(7);
	printf("%d ", a);
	a = fibonacci(8);
	printf("%d ", a);
	a = fibonacci(46);
	printf("%d ", a);
	a = fibonacci(48);    // a=-1
	printf("%d ", a);
	a = fibonacci(0);     // a=0
	printf("%d ", a);

	return 0;
}