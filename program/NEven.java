import java.util.*;
public class NEven
{
	public static void main(String []args)
	{
		int Number;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a number:");
		Number=s.nextInt();
		for(int i=1;i<=Number;i++)
		{
			if(i%2==0)
				System.out.println(i+" is even");
		}
		
	}
}
