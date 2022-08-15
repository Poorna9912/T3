package Array;

public class Even {
	public static void main (String args[]) {
   int a[] = {2,4,11,7,9,10};
   System.out.println("Even numbers");
   for(int i=0; i<a.length; i++) 
   {
	   if(a[i]%2==0)
	   System.out.println(a[i]);
   }
   System.out.println("Odd numbers");
   for(int i=0; i<a.length; i++) 
   {
	   if(a[i]%2!=0)
	   System.out.println(a[i]);
   }
	}
}
