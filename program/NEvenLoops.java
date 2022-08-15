import java.util.*;
public class NEvenLoops
{
	public static void main(String []args)
	{
		int Number,i=1;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a number:");
		Number=s.nextInt();
		System.out.println("using for loop");
		for(;i<=Number;i++)
		{
			if(i%2==0)
				System.out.println(i+" is even");
		}
		System.out.println("using while loop");
		i=1;
		while(i<=Number)
		{
			if(i%2==0)
				System.out.println(i+" is even");
		   i++;			
		}
		
		System.out.println("using dowhile loop");	
		i=1;			
		do
		{
			if(i%2==0)
				System.out.println(i+" is even");
		   i++;
		}
		while( i<=Number);
	}
}
