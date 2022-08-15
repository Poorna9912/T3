import java.io.*;
import java.util.Scanner;
public class FandL
{
 public static void main(String []args)
 {
   int n,f=0,l=0;
  Scanner sc = new Scanner(System.in);
  System.out.println("enter the value : ");
  n=sc.nextInt();
  l=n%10;
  System.out.println("last digit : "+l);
 
    while(n!=0)
  {
  
  f=n%10; 
  n=n/10;
  }
   System.out.println("first digit : "+f);
  }
  }
