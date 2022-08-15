import java.io.*;
import java.util.*;
public class Prime
{
 public static void main (String []args)
 {
  int a;
  int count=0;
  Scanner sc=new Scanner(System.in);
  System.out.println("Eneter the number : ");
  a=sc.nextInt();
  if(a>1)
  {
  for(int i=1;i<=a;i++)
  {
   if(a%i==0)
   {
     count ++;
     }
     }
     if(count==2)
   {
   System.out.println("its prime number");
   }
   else
   {
    System.out.println("its not prime number");
   }
   }
   else
   {
    System.out.println("its not prime number");
   }
   }
 }
