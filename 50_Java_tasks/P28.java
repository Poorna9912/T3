import java.util.Scanner;
class P28
{
 public static void main(String args[])
 {
  Scanner sc = new Scanner(System.in);
  System.out.println("Enter a number");
  int n = sc.nextInt();
  if(n>=1 && n<=10)
   System.out.println("'"+n+"'"+" You have entered a number from the range 1-10");
  else 
   System.out.println("'"+n+"'"+"You have entered a number outside the range 1-10");
 }
}
