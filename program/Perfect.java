import java.util.*;
public class Perfect
{
	public static void main(String[] args)
	{
		int s=0,i,n;
		Scanner sc=new Scanner(System.in);
		System.out.println("Enetr a number");
		n=sc.nextInt();
		for(i=1;i<n;i++)
		{
			if(n%i==0)
				s=s+i;
		}		
		if(s==n)
			System.out.println(n+" is perfect number");
		else
			System.out.println(n+" is not perfect Number:");
	}
}
