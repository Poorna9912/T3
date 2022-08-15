import java.util.Scanner;
class P30
{
 public static void main(String args[])
 {
  System.out.println("Enter a number");
  Scanner sc = new Scanner(System.in);
  int n=sc.nextInt();
  int org=n;
  int rem;
  int rev = 0;
  while(n != 0)
  { 
   rem=n%10;
   rev = rev * 10 +rem;
   n/=10;
  }
  if(org==rev)
   System.out.println(org+" is a PALINDROME");
  else
   System.out.println(org+" is NOT a PALINDROME");
 }    
} 
