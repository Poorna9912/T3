import java.util.Scanner;
class P23
{
 public static double factorial(double a)
  {
   if(a == 0)
    return 1;
   else 
    return a*factorial(a-1);
  } 
 public static void main(String args[])
 {
  Scanner sc = new Scanner(System.in);
  System.out.println("Enter 'n' value");
  double n=sc.nextInt();
  System.out.println("Enter 'x' value");
  double x=sc.nextInt();
  double k=0;
  for(int i=1;i<=n;i++)
   k += Math.pow(x,i)/(factorial(i));
  System.out.println("the sum of the series 1+"+x+"/1!+"+x+"^2/2!+"+x+"^3/3!......+"+x+"^"+n+"/"+n+"! is "+(1+k)); 
 }
}    
 
