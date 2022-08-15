import java.io.*;
import java.util.Scanner;
public class DorL
{
 public static void main(String []args)
 {
 char c;
  Scanner sc=new Scanner(System.in);
  System.out.println("Enter the value : ");
  c =sc.next().charAt(0);
  if((c>='a' && c<='z')||(c>='A' && c<='Z'))
  {
   System.out.println(c+" is Character");
  }
  else if(c>='0' && c<='9')
  {
  System.out.println(c+" is digit");
  }
  else
  {
  System.out.println("special character");
  }
 }
}
