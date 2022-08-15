import java.util.*;
public class TerenaryCompare
{
	public static void main(String[] args)
	{
		int Number1,Number2;
		System.out.println("Enter 2 Numbers:");
		Scanner s=new Scanner(System.in);
		Number1=s.nextInt();
		Number2=s.nextInt();
		int Result=(Number1>Number2)?Number1:Number2;
		System.out.println(Result+":is larger");
	}
}
