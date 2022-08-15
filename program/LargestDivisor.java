import java.util.*;
public class LargestDivisor
{
	public static void main(String[] args)
	{
		int la,i,c,j,n;
		Scanner s=new Scanner(System.in);
		System.out.println("enter the size:");
		n=s.nextInt();
		int a[]=new int[n];
		for(i=1;i<=n;i++)
		{
		   c=0;
		   j=1;
		  for(;j<=i;j++)
		  {
		  	if(i%j==0)
		  		c++;
		 // System.out.println(j+" "+c);
		  }	
		  		
		  a[i-1]=c;
		   //System.out.println(a[i-1]);
		}
		la=a[0];
		 //System.out.println("the largest "+la);
		for(i=0;i<n-1;i++)
		{
			if(la<a[i+1])
				la=a[i+1];	
		}
		System.out.println("The largest digit: "+la);
	}	
}
