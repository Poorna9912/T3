import java.util.*;
public class Prime
{
	public static void main(String []args)
	{
		int j,i,count;
		Scanner s=new Scanner(System.in);
		System.out.println("Eneter a range:");
		int n=s.nextInt();
		for(j=2;j<n+1;j++)
		{
			i=1;count=0;
			for(;i<=j;i++)
			{
				if(j%i==0)
					count++;
				
			}
			if(count==2)
				System.out.println(j+": is prime");
		}
	
	}	
}
