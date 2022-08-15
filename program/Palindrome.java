import java.util.*;
public class Palindrome
{
	public static void main(String[] args)
	{
		int n,rev=0,re=0;
		Scanner s=new Scanner(System.in);
		System.out.println("Enter a number:");
		n=s.nextInt();
		int n1=n;
		while(n!=0)
		{
			re=n%10;
			rev=rev*10+re;
			n=n/10;
		}
		if(rev==n1)
			System.out.println(n1+" is palindrome");
		else
			System.out.println(n1+" is not palindrome");
	}
}
