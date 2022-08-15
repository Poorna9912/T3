import java.util.Scanner;
class P2
{
 public static void main(String args[])
 {
  System.out.println("Enter a Number");
  Scanner sc = new Scanner(System.in);
  double num = sc.nextDouble();
  if(num == 0)
   System.out.println("Given number is neither Negative nor Positive");
  else if(num%2 == 0)
   System.out.println("Given number is EVEN");
  else
   System.out.println("Given numeber is ODD");
 }
}  
