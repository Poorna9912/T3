import java.util.*;
public class ConvertTime
{
	public static void main(String[] args)
	{
		int ti;
		Scanner s=new Scanner(System.in);
		System.out.println("Enter time in 24 hours format:");
		ti=s.nextInt();
		System.out.println(3600*ti);
	}
}
