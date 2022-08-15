import java.util.*;
public class NPrime
{
	public static void main(String []args)
	{
		int k,j,n1=0,i=2,count;
		Scanner s=new Scanner(System.in);
		System.out.println("Eneter a range:");
		int n=s.nextInt();
		while(n!=n1)
		{
			count=0;
			for(j=1;j<=i;j++)
			{
	 			if(i%j==0)
					count++;
			//System.out.println("count");
						
			}
					if(count==2)
						{
						  System.out.println(i);
						   n1++;
						 }
			i++;
		//System.out.println("hi");
		}
	}	
}
