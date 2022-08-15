import java.util.*;
public class Pattern
{
	public static void main(String[] args)
	{
		int n,i,j,k,l,m;
		Scanner s= new Scanner(System.in);
		System.out.println("enter a number");
		n=s.nextInt();
		for(i=1;i<=n;i++)
		{
			for(j=1;j<=n-i;j++)
			{
				System.out.print(" ");
			}
			l=i;
			
			for(k=1;k<=i;k++)
			{	
				System.out.print(l);
				l--;
			}
			m=2;
			for(j=1;j<i;j++)
			{
			      System.out.print(m);
			      m++;
			}
			
			System.out.println();
		}
	
	}
}
