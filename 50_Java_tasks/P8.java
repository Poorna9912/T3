import java.util.Scanner;
 class P8
 {
  public static void main(String args[])
  {
   Scanner sc = new Scanner(System.in);
   System.out.println("Enter the value of a");
   double n1=sc.nextDouble();
   System.out.println("Enter the value of b");
   double n2=sc.nextDouble();
   if(n1>n2)
    System.out.println(n1+" is the BIGGEST number");
   else
    System.out.println(n2+" is the BIGGEST number");
  }  
 } 
 
