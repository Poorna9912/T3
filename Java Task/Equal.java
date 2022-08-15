import java.io.*;
import java.util.Scanner;
public class Equal
{
 public static String CheckSameDigits(int n)
 {
  int digit=n%10;
  while(n!=0)
  {
   int current=n%10;
   n= n/10;
   if(current!=digit)
   {
    return "no";
   }
  }  
  return "yes";
 }
  public static void main(String []args)
  
  {
  int n;
  Scanner sc = new Scanner(System.in);
  System.out.println("Enter the value to check equal or not : ");
  n=sc.nextInt();
  System.out.println(CheckSameDigits(n));
  }
}
