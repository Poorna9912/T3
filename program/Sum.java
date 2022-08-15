import java.util.*;
public class Sum
{
	public static void main(String []args)
	{
		int Number,j=1;
		double Total=0.0;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a number:");
		Number=s.nextInt();
		for(double i=1.0;i<=Number;i++)
		{
				
				Total=Total+1/i;
		}
		System.out.println("The Sum of the Number:"+Total);
	}
}
