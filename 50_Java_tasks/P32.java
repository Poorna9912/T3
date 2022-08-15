import java.util.Scanner;
class P32
{
 public static void main(String args[])
 {
  Scanner sc = new Scanner(System.in);
  System.out.println("Enter a number for multiplication table"); 
  int a = sc.nextInt();
  int n=0;
  do 
  {
   int r = a*n;
   System.out.println(a+"*"+n+"="+r);
   n++;
  }
  while(n<=20);
 }
}   
