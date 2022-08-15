import java.io.*;
import java.util.*;
public class Pattern3
{
 public static void main(String []args)
 {
 int row;
 Scanner sc=new Scanner(System.in);
 System.out.println("enter the value : ");
 row=sc.nextInt();
 System.out.println("");
 for(int i=1;i<=row;i++)
 {
  for(int j=0;j<=row-i;j++)
  {
   System.out.print(" ");
  }
  for(int k=1;k<i;k++)
  {
   System.out.print(k);
  }
  for(int l=i;l>=1;l--)
  {
   System.out.print(l);
  }
  System.out.println(" ");
 }
 }
 
}
