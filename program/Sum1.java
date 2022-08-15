import java.util.*;
import java.lang.Math;
public class Sum1
{
	public static void main(String []args)
	{
		int Number,j=2;
		double Total=0.0;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a number:");
		Number=s.nextInt();
		for(int i=1;i<=Number;i++)
		{
				
				Total=Total+(1/Math.pow(j,i));
				//System.out.println("The Sum of the Number:"+Total);
		}
		Total=Total+1/1;
		System.out.println("The Sum of the Number:"+Total);
	}
}
