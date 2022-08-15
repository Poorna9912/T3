import java.io.*;
import java.util.*;
public class Biggest
{
 public static void main(String []args)
 {
  int i,j;
  Scanner sc=new Scanner(System.in);
  System.out.println("Enter the value : ");
  i=sc.nextInt();
  System.out.println("Enter the value : ");
  j=sc.nextInt();
  if(i==j)
  {
   System.out.println("the two numbers are equal");
  }
  else if(i>j)
  {
  System.out.println(i+" is the biggest number");
  }
  else if(i<j)
  {
  System.out.println(j+" is the biggest number ");
  }
  else
  {
  System.out.println("enter the valid numbers");
  }
 }
}
