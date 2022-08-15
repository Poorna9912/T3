import java.util.*;
public class Divisible
{
	public static void main(String[] args) 
	{
		int Number;
		System.out.println("enter a Number:");
		Scanner s=new Scanner(System.in);
		Number=s.nextInt();
		if((Number%3==0)&&(Number%5==0))
			System.out.println(Number+"is divisible by 3 and 5");
		else
			System.out.println(Number+"is not divisible by 3 and 5");	
	}
}
