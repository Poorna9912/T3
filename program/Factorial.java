import java.util.*;
public class Factorial
{
	public static void main(String[] args)
	{
		int re=1,n,i;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a number");
		n=s.nextInt();
		for(i=n;i>=1;i--)
		{
			re=re*i;
		}
		System.out.println("The result:"+re);
	}
}	
