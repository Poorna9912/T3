import java.util.*;
public class PrintSeries
{
	public static void main(String[] argts)
	{
		int i,n;
		Scanner s=new Scanner(System.in);
		System.out.println("Enter range:");
		n=s.nextInt();
		System.out.print("1+");
		for(i=1;i<=n;i++)
		{
			System.out.print("x^"+i+"/"+i);
			if(i<=n)
			  System.out.print("!");
			if(i<n)
			   System.out.print("+"); 			
		}
		System.out.println();
		
	}
}
