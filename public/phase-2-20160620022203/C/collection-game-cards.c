// Name : Collection Game Cards
#include <stdio.h>
int main() {
	// input:
	// n : the number of cards on the assembly line
	// a : cards
	int n, a[100], result=1, index;
	scanf("%d", &n);
	for(index = 0; index< n; index++) {
		scanf("%d", &a[index]);
	}


	// write your code here
	// store your results in `result`

	// output
	printf("%d", result);
	return 0;
}