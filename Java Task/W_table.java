import java.io.*;
import java.util.*;
public class W_table
{
 public static void main (String []args)
 {
  int a;
  Scanner sc=new Scanner(System.in);
  System.out.print(" pleace enter which table you want : ");
  a=sc.nextInt();
  int i=1;
  while(i<=20)
  {
   System.out.println(a+" X "+i+" = "+(a*i));
   i++;
  }
  }
 }
