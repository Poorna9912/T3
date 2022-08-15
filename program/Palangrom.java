import java.util.*;
public class Palindrome
{
	publilc static void main(String[] args)
	{
		int n,rev=0;
		Scanner s=new Scanner(System.in);
		System.out.println("Enter a number:");
		n=s.nextInt();
		While(n>0)
		{
			re=n%10;
			rev=rev*10+re;
			n=n/10;
		}
		if(rev==n)
			System.pout.println(n+" is palindrome"):
		else
			System.pout.println(n+" is not palindrome"):
	}
}
