import java.util.Scanner;
class Cube
 {
  public static void main(String args[])
  {
   System.out.println("Enter a number");
   Scanner sc = new Scanner(System.in);
   double n=sc.nextDouble();
   double cu=Math.pow(n,3);
   System.out.println("The cube of the given number is "+cu);
  }
 }  
