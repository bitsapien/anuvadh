// Name : Supergame
using System;
namespace Application {
	class supergame {
		public static void Main(string[] args) {
		// input:
		// n : number of boys
		// a :  number of rounds each boy wants to play
		int index;
		int n = Convert.ToInt32(Console.ReadLine());
		int[] a = new int[n];
		string[] a_elements = (Console.ReadLine()).Split(' ');
		for(index=0;index<n;index++)
			a[index] = Convert.ToInt32(a_elements[index]);


		// write your code here
		// store your results in `result`

		// output
		// Dummy Data
		int result=4;

		Console.WriteLine(result);

		}	
	}
}