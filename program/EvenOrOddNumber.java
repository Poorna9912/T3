import java.util.*;
public class EvenOrOddNumber
{
	public static void main(String[] args)
	{
		Scanner s= new Scanner(System.in);
		System.out.println("enter a number:");
		int Number=s.nextInt();
		if(Number%2==0)
			System.out.println(Number+"is even");
		else
			System.out.println(Number+"is odd");
	}

}
