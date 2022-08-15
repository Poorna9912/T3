import java.io.*;
import java.util.*;
public class Pass
{
 public static void main(String []args)
 {
  int i;
  Scanner sc=new Scanner(System.in);
  System.out.print("Enter the value : ");
  i=sc.nextInt();
  if(i>=90 && i<=100)
  {
   System.out.println("pass");
      System.out.println("rank : A");
  }
  else if(i>=70 && i<=89)
  {
   System.out.println("pass");
      System.out.println("rank : B");
  }
  else if(i>=60 && i<=69)
  {
   System.out.println("pass");
      System.out.println("rank : C");
  }
  else if(i>=50 && i<=59)
  {
   System.out.println("pass");
      System.out.println("rank : D");
  }
  else if(i>=40 && i<=49)
  {
   System.out.println("pass");
      System.out.println("rank : E");
  }
  else
  {
  System.out.println("fail");
  }
 }
 }
