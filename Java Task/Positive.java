import java.io.*;
import java.util.*;
public class Positive
{
 public static void main(String []args)
 {
  int i;
  Scanner sc=new Scanner(System.in);
  System.out.println("Enter the value : ");
  i=sc.nextInt();
  if(i>0)
  {
   System.out.println("positive");
  }
  else if(i<0)
  {
  System.out.println("negative");
  }
  else
  {
  System.out.println("the value is zero");
  }
 }
}
