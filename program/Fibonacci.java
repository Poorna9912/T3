import java.util.*;
public class Fibonacci
{
	public static void main(String[] args)
	{
		int ra,i,re=0;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a range");
		ra=s.nextInt();
		int sum=0,sum1=1;
		if((ra==0)||(ra>=1))		
		System.out.print(sum+" ");
		if(ra>=1)		
		System.out.print(sum1+" ");
		for(i=2;i<=ra;i++)
			{
				re=sum+sum1;
				sum=sum1;
				sum1=re;
				System.out.print(re+" ");	
			}
			
		System.out.println();
		/*
		to print fib(n);
		System.out.println(re);
		*/
	}
}
