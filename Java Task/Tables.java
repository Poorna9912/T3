import java.io.*;
import java.util.*;
public class Tables
{
 public static void main (String []args)
 {
  int a;
  Scanner sc=new Scanner(System.in);
  System.out.print("Enter the number : ");
  a=sc.nextInt();
  for(int i=1;i<=20;i++)
  {
  System.out.println(a+" X "+i+" = "+(a*i));
  }
 }
}
