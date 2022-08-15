import java.io.*;
import java.util.Scanner;
public class LDinN
{
 public static void main(String []args)
 {
   int n,s,l=0;
  Scanner sc = new Scanner(System.in);
  System.out.println("enter the value : ");
  n=sc.nextInt();
  while(n>0)
  {
 
  s=n%10;
  if(l<s)
  {
   l=s;
  }
   
  n=n/10;
  
   System.out.println("big digit : "+l);
  }
}
}
