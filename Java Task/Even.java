import java.io.*;
import java.util.*;
public class Even
{
 public static void main(String []args)
 {
  int i;
  Scanner sc=new Scanner(System.in);
  System.out.println("Enter the value : ");
  i=sc.nextInt();
  if(i%2==0)
  {
   System.out.println("Even");
  }
  else
  {
  System.out.println("odd");
  }
 }
}
