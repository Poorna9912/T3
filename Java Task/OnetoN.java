import java.io.*;
import java.util.Scanner;
public class OnetoN
{
 public static void main(String []args)
 {
   int n,sum=0;
  Scanner sc = new Scanner(System.in);
  System.out.println("enter the value : ");
  n=sc.nextInt();
  for(int i=1;i<=n;++i)
  {
   sum=sum+i;
  }
   System.out.println(" sum of one to "+n+" is : "+sum);
  }
  }
