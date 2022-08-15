import java.io.*;
import java.util.*;
public class Range
{
 public static void main (String []args)
 {
  int a;
  Scanner sc=new Scanner(System.in);
  System.out.print("Eneter a number between 1 to 10 : ");
  a=sc.nextInt();
  if(a>=1 && a<=10)
  {
  System.out.println("you enterd : "+a);
  }
  else
  { 
     System.out.println("enetr valid number");
  }
  }
 }
