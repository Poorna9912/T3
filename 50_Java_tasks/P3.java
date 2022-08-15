import java.util.Scanner;
class P3
{
 public static void main(String args[])
 {
  System.out.println("Enter a year");
  Scanner sc = new Scanner(System.in);
  int year = sc.nextInt();
  if(year >= 100)
  {
   if((year%400==0) || ((year%100!=0)&&(year%4==0)))
    System.out.println("The given year is a LEAP YEAR");
   else
    System.out.println("The given number is NOT A LEAP YEAR");
  }
  else
   System.out.println("The given number is not a year");  
 } 
}  
