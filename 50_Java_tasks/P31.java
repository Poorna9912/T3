import java.util.Scanner;
class P31
{
 public static void main(String args[])
 {
  Scanner sc = new Scanner(System.in);
  System.out.println("Enter the last number you need in fibonocci series");
  int n = sc.nextInt();
  System.out.println("Enter the first two numbers");
  int a = sc.nextInt();
  int b = sc.nextInt();
  int c;
  for(int i=0;i<=n;i++)
  {
   c=a+b;
   System.out.println(c);
   a=b;
   b=c;
  }
 }  
} 
