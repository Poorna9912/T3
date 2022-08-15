import java.util.*;
public class AddNumbers
{
	public static void main(String[] args)	
	{
		int n,sum=1;
		Scanner s=new Scanner(System.in);
		n=s.nextInt();
		if(n<=48)
		{ sum=sum+n;
			System.out.println(sum);
		}
	}
}
