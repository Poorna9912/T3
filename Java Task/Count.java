import java.io.*;
import java.util.*;
public class Count
{
 public static void main(String []args)
 {
  int i,count=0;
  Scanner sc=new Scanner(System.in);
  System.out.println("Enter the value : ");
  i=sc.nextInt();
  while(i!=0)
  {
   i=i/10;
   count++;
   }
  System.out.println("answer : "+count);
 }
}
