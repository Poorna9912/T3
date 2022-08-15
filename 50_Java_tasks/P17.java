import java.util.Scanner;
 class P17
 {
  public static void main(String args[])
  {
   Scanner sc = new Scanner(System.in);
   System.out.println("Enter the number of even numbers you want the sum of...");
   int n = sc.nextInt();
   int p = 0;
   int q = p;
   for(int i=1;i<=n;i++)
   {
    p = 2*i;
    q += p;
   }
   System.out.println("The sum of first "+n+" even numbers is "+q); 
  }
 }
