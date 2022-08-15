import java.util.*;
public class SumEven
{
	public static void main(String []args)
	{
		int Number,Total=0;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a number:");
		Number=s.nextInt();
		for(int i=1;i<=Number;i++)
		{
			if(i%2==0)
				Total=Total+i;
		}
		System.out.println("The Sum of the even Number:"+Total);
	}
}
