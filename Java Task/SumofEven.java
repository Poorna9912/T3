import java.io.*;
import java.util.*;
public class SumofEven
{
 public static void main (String []args)
 {
  int a,b=0;
  Scanner sc=new Scanner(System.in);
  System.out.print("Eneter the number : ");
  a=sc.nextInt();
  for(int i=1;i<=a;i++)
 {
  if(i%2==0)
   {
    b=b+i;
   }
  }
System.out.println("the sum of even numbers up to "+a+" is :  "+b);
}
}

