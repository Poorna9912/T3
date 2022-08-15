import java.io.*;
import java.util.*;
public class Division
{
 public static void main(String []args)
 {
  int i;
  Scanner sc=new Scanner(System.in);
  System.out.println("Enter the value : ");
  i=sc.nextInt();
  if(i%3==0 && i%5==0)
  {
   System.out.println("this number is divisible by 3 and 5");
  }
  else
  {
  System.out.println("this number is not divisible by 3 and 5");
  }
 }
 }
