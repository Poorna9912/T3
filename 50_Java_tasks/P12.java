import java.util.Scanner;
class P12
{
 public static void main(String args[])
 {
  System.out.println("Enter some values");
  Scanner sc = new Scanner(System.in);
  double a = sc.nextDouble();
  double b = sc.nextDouble();
  double c;
  System.out.println("Enter the operation you want to perform");
  char op = sc.next().charAt(0);
  switch(op)
  {
   case '+' : c=a+b;
    System.out.println("The Addition of the given numbers is "+c);
    break;
   case '-' : c=a-b;
    System.out.println("The Substraction of the given numbers is "+c);
    break;
   case '*' : c=a*b;
    System.out.println("The Product of the given numbers is "+c);
    break;
   case '/' : c=a/b;
    System.out.println("The Quotient of the given numbers is "+c);
    break;  
   case '%' : c=a%b;
    System.out.println("The Reminder of the given number is "+c);
    break;
   default : System.out.println("You have given the invalid operator"); 
    return;
  }
 }  
} 
