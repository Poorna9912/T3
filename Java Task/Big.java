import java.io.*;
import java.util.*;
public class Big
{
 public static void main(String []args)
 {
  int a,b,c;
  Scanner sc=new Scanner(System.in);
  System.out.print("Enter the value of a : ");
  a=sc.nextInt();
  System.out.print("Enter the value b : ");
  b=sc.nextInt();
  System.out.print("Enter the value c : ");
  c=sc.nextInt();
  if(a>b && a>c)
  {
   System.out.println(a+" is biggest number");
    
  }
  else if(b>c)
  {
   System.out.println(b+ " is biggest number");

  }
   else if(c>b)
  {
   System.out.println(c+ " is biggest number");

  }
  else
  {
  System.out.println("Enter correct integer!!!");
  }
 }
 }
