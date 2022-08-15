import java.util.Scanner;
 class P14
 {
  public static void main(String args[])
  {
   Scanner sc = new Scanner(System.in);
   System.out.println("Enter a number for Multiplication Table");
   int num = sc.nextInt();
   for(int i=0 ; i<=20 ; i++)
   {
    int p = num*i;
    System.out.println(num+" * "+i+" = "+p);
   }
  }
 }   

