import java.util.Scanner;
 class P1
 {
  public static void main(String args[])
  {
   System.out.println("Enter a number");
   Scanner sc = new Scanner(System.in);
   double num = sc.nextDouble();
   if(num>0)
    System.out.println("The given number "+num+", is POSITIVE");
   else if(num<0)
    System.out.println("The given number "+num+", is NEGATIVE");
   else 
    System.out.println("The given number "+num+", is neither NEGATIVE nor POSITIVE");
   }
  }   
