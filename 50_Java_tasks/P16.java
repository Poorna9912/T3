import java.util.Scanner;
 class P16
 {
  public static void main(String args[])
  {
   Scanner sc = new Scanner(System.in);
   System.out.println("Enter the number of even numbers you want !");
   int n = sc.nextInt();
   System.out.println("The "+n+" even numbers are...");
   for(int i=1;i<=n;i++)
   {
    int p = 2*i;
    System.out.print(p+" ");
   } 
  }
 }
