import java.util.Scanner;
class Sumndavg
{
 public static void main(String args[])
 {
  System.out.println("Enter three numbers");
  Scanner sc = new Scanner(System.in);
  int a = sc.nextInt();
  int b = sc.nextInt();
  int c = sc.nextInt();
  int sum = a+b+c;
  double avg = sum/3;
  System.out.println(sum);
  System.out.println(avg);
  }
} 
  

