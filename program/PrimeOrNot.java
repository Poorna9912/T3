import java.util.*;
public class PrimeOrNot
{
	public static void main(String[] args)
	{
		int n,i,c=0,f=0;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a number: ");
		n=s.nextInt();
		for(i=1;i<=n;i++)
		{
			if(n%i==0)
				c++;
			if(c>2)
				{
				   f=1;
				   System.out.println(n+" is not prime");
				   break;	
				}	
		}
		if(f==0)
			System.out.println(n+" is prime");
	}
}
