import java.util.*;
public class TerenaryCompare1
{
	public static void main(String[] args)
	{
		int Number1,Number2,Number3;
		System.out.println("Enter 3 Numbers:");
		Scanner s=new Scanner(System.in);
		Number1=s.nextInt();
		Number2=s.nextInt();
		Number3=s.nextInt();
		int Result=(Number1>Number2)?((Number1>Number3)?Number1:Number3):((Number2>Number3)?Number2:Number3);
		System.out.println(Result+":is larger");
	}
}
