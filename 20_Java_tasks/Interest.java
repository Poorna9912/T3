import java.util.Scanner;
class Interest
{
 public static void main(String args[])
 {
  System.out.println("Enter the rate of Interest");
  Scanner sc = new Scanner(System.in);
  double loan_amount = 856231;
  double rate = sc.nextDouble();
  double Interest = loan_amount*rate;
  System.out.println(Interest);
 }
}  
