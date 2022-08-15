import java.util.Scanner;
 class P10
 {
  public static void main(String args[])
  {
   Scanner sc = new Scanner(System.in);
   System.out.println("Enter the value of a");
   double n1=sc.nextDouble();
   System.out.println("Enter the value of b");
   double n2=sc.nextDouble();
   System.out.println("Enter the value of c");
   double n3=sc.nextDouble();
   double big = (n1>n2) ? (n1>n3 ? n1 : n3) : (n2>n3 ? n2 : n3);
   System.out.println("The bigger number is "+big);
  }  
 } 
 
