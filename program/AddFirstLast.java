import java.util.*;
public class AddFirstLast
{
	public static void main(String[] args)
	{
		int n,n1,f,l=0,s=0,re=0;
		Scanner sc=new Scanner(System.in);
		System.out.println("Enter a number ");
		n=sc.nextInt();
		n1=n;
		f=n%10;
		s=s+f;
		n=n/10;
		while(n>0)
		{
			l=n%10;
			n=n/10;		
		}
		s=s+l;
		System.out.println(n1+" The sum of first and last: "+s);
	}
}
