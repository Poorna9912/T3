import java.util.*;
public class BigDigit
{
	public static void main(String[] args)
	{
		int re=0,n,b=0;
		Scanner s=new Scanner(System.in);
		n=s.nextInt();
		while(n>0)
		{
			re=n%10;
			if(re>b)
				b=re;
			n=n/10;	
		}
		System.out.println(b);
	}
}
