import java.util.Scanner;
class P21
{
 public static void main(String args[])
 {
  System.out.println("Enter 'n' value");
  Scanner sc = new Scanner(System.in);
  double n=sc.nextInt();
  double k=0;
  for(double j=1;j<=n;j++)
   k += 1/j;
  System.out.println("the sum of 1/1,1/2,1/3,1/4......1/n is "+k); 
 }
}    
 
