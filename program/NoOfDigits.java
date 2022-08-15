import java.util.*;
public class NoOfDigits
{
	public static void main(String[] args)
	{
		int n,c=0;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a digit:");
		n=s.nextInt();
		while(n>0)
		{
			c++;
			n=n/10;	
		}
		
		System.out.println("the no digits: "+c);
		
	}
}
