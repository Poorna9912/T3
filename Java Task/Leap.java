import java.io.*;
import java.util.*;
public class Leap
{
 public static void main(String []args)
 {
  int i;
  Scanner sc=new Scanner(System.in);
  System.out.println("Enter the value : ");
  i=sc.nextInt();
  if(((i%4==0)&&(i%100!=0))||(i%400==0))
  {
   System.out.println("leap year");
  }
  else
  {
  System.out.println("not a leap year");
  }
 }
}
