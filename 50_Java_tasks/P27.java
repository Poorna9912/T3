import java.util.Scanner;
class P27
{
 public static void main(String args[])
 {
  Scanner sc = new Scanner(System.in);
  System.out.println("Enter a number");
  int num=sc.nextInt();
  int sum = 0;
  for(int i=1;i<num;i++)
  {
   if(num%i==0)
    sum += i;
  }
  if(sum == num)
   System.out.println("The given number '"+num+"' is a perfect number");
  else
   System.out.println("The given number '"+num+"' is NOT a perfect number");
 }
}  
    
  
