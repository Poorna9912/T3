import java.util.*;
public class BigNumber
{
	public static void main(String[] args)
	{
		int Number1,Number2;
		System.out.println("Enter 2 Numbers:");
		Scanner s=new Scanner(System.in);
		Number1=s.nextInt();
		Number2=s.nextInt();
		if(Number1>Number2)
			System.out.println(Number1+":is larger");
		else
			System.out.println(Number2+":is larger");
	}
}
