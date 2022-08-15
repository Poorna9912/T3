import java.io.*;
import java.util.Scanner;
public class MMA
{
 public static void main(String []args)
 {
  int n,r,min,max;
  Scanner sc = new Scanner(System.in);
  System.out.println("enter the value : ");
  n=sc.nextInt();
  min=Integer.MAX_VALUE;
  max=Integer.MIN_VALUE;
  while(n>0)
  {
   r=n%10;
   if(min<n)
  {
    n=min;
  }
  if(max>n)
  {
   max=n;
  }
   
  n=n/10;
  
   System.out.println("max : "+max+" and min" +min );
  }
}
}
