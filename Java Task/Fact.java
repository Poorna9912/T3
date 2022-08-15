import java.io.*;
import java.util.*;
public class Fact
{
 public static int factorial(int a)
 {
if(a == 0)
return 1;
else
 return a*factorial(a-1);
}
 public static void main (String []args)
{
  Scanner sc=new Scanner(System.in);
  System.out.print("Eneter 'a' value : ");
  int a=sc.nextInt();
System.out.println("The factorial of "+a+" is :  "+factorial(a));
}
}

