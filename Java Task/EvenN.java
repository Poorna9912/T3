import java.io.*;
import java.util.*;
public class EvenN
{
 public static void main (String []args)
 {
  int a;
  Scanner sc=new Scanner(System.in);
  System.out.print("Eneter the number : ");
  a=sc.nextInt();
  for(int i=1;i<=a;i++)
  {
  if(i%2==0)
  {
  System.out.println(i+"  ");
  }
  }
 }
}
