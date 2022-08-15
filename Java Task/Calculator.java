import java.io.*;
import java.util.Scanner;
public class Calculator
{
 public static void main(String []args)
 {
  int a,b,c,add,sub,mul;
  double div;
  Scanner sc=new Scanner(System.in);
  System.out.println("Enter the value of a : ");
  a=sc.nextInt();
  System.out.println("Enter the value of b : ");
  b=sc.nextInt();
  while(true)
  {
   System.out.println("enter 1 for additon : ");
   System.out.println("enter 2 for subtraction : ");
   System.out.println("enter 3 for multipplication : ");
   System.out.println("enter 4 for division : ");
   System.out.println("enter 5 for exit : ");
   c=sc.nextInt();
   switch(c)
  {
   case 1:
   add=a+b;
   System.out.println("addition : "+add);
   break;
   case 2:
   sub=a-b;
   System.out.println("subtraction : "+sub);
   break;
   case 3:
   mul=a*b;
   System.out.println("multipication : "+mul);
   break;
   case 4: 
   div=(double)a/b;
   System.out.println("division : "+div);
   break;  
   case 5: 
   System.exit(0);
   break;
  }
 }
}
}
