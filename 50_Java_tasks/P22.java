import java.util.Scanner;
class P22
{
 public static void main(String args[])
 {
  System.out.println("Enter 'n' value");
  Scanner sc = new Scanner(System.in);
  double n=sc.nextInt();
  double k=0;
  for(double i=1;i<=n;i++)
   k += 1/Math.pow(2,i);
  System.out.println("the sum of 1/1,1/2,1/2^2,1/2^3......1/n is "+(1+k)); 
 }
}    
 
