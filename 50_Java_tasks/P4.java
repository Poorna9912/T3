import java.util.Scanner;
class P4
{
 public static void main(String args[])
 {
  System.out.println("Enter a number");
  Scanner sc = new Scanner(System.in);
  int num = sc.nextInt();
  if(num%3 == 0 && num%5 ==0)
    System.out.println("The given number is divisible by both 3 & 5");
   else
    System.out.println("The given number is not divisible by both 3 & 5"); 
 } 
} 
