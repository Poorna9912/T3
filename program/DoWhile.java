import java.util.*;
public class DoWhile
{
	public static void main(String[] args)
	{
		int i=1,r,n;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a number:");
		n=s.nextInt();
		System.out.println("enter a range:");
		r=s.nextInt();
		do
		{
			System.out.println(n+"*"+i+"="+n*i);
			i++;
		}
		while(i<=r);
		
	}
}
