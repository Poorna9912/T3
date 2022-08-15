import java.util.*;
public class MultiplicationTables
{
	public static void main(String []args)
	{
		int Number,EndNumber,LastTable;
		Scanner s=new Scanner(System.in);
		System.out.println("Enter a number:");
		Number=s.nextInt();
		System.out.println("Enter a endnumber ");
		EndNumber=s.nextInt();
		System.out.println("Enter a last table ");
		LastTable=s.nextInt();
		for(;Number<=EndNumber;Number++)
		{	
		System.out.println(Number+" table" );
			for(int i=1;i<=LastTable;i++)
			{
				System.out.println(Number+"*"+i+"="+(Number*i));
			}
		System.out.println("----------------------------- ");	
		}	
	}
}
