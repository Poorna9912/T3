import java.util.Scanner;
class P34
{
 public static void main(String[] args)
 {
  Scanner sc = new Scanner (System.in);
  System.out.println ("Enter the number");
  int num = sc.nextInt ();
  int reminder;
  int Largest = 0;
  while (num > 0)
  {
   reminder = num % 10;
   if (Largest < reminder) 
   {
    Largest = reminder;
   }
   num = num / 10;
  }
  System.out.println("\nThe Largest Digit is "+Largest);
 }
}

