import java.util.*;
public class MultiplicationTable
{
	public static void main(String []args)
	{
		int Number,EndNumber;
		Scanner s=new Scanner(System.in);
		System.out.println("Enter a number:");
		Number=s.nextInt();
		System.out.println("Enter a last number ");
		EndNumber=s.nextInt();
		for(int i=1;i<=EndNumber;i++)
		{
			System.out.println(Number+"*"+i+"="+(Number*i));
		}
		
	}
}
