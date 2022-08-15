import java.util.*;
public class ConvertHours
{
	public static void main(String[] args)
	{
	        final float SECONDS_PER_HOUR=3600;
	        int se;
		Scanner s=new Scanner(System.in);
		System.out.println("Enter seconds:");
		se=s.nextInt();
		System.out.println(se/SECONDS_PER_HOUR);
	}
}
