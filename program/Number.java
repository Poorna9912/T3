import java.util.*;
public class Number
{
	public static void main(String[] args)
	{
		Scanner s= new Scanner(System.in);
		System.out.println("enter a number:");
		int Number=s.nextInt();
		if(Number>0)
			System.out.println(Number+"is positive");
		else
			System.out.println(Number+"is negitive");
	}

}
