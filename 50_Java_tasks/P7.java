import java.util.Scanner;
 class P7
 {
  public static void main(String args[])
  {
   Scanner sc = new Scanner(System.in);
   System.out.println("Enter the x co-ordinate");
   double x = sc.nextDouble();
   System.out.println("Enter the y co-ordinate");
   double y = sc.nextDouble();
   if(x == 0 && y == 0)
    System.out.println("The given co-ordinates lies on the ORIGIN");
   else if(x>0 && y==0)
    System.out.println("The given co-ordinates lies on the X-AXIS");
   else if(x==0 && y>0) 
    System.out.println("The given co-ordinates lies on the Y-AXIS");
   else if(x>0 && y>0)
   System.out.println("The given co-ordinates lies inbetween the X&Y AXIS or Q1");
   else 
   System.out.println("The given co-ordinates lies outside the X&Y AXIS or inbetween Q2/Q3/Q5");
   }
  }   
