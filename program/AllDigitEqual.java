import java.util.*;
public class AllDigitEqual
{
	public static void main(String[] args)
	{
		int n,re,re1,flag=0;
		Scanner s=new Scanner(System.in);
		System.out.println("Enter a number");
		n=s.nextInt();
		re=n%10;
		while(n>0)
		{	
			n=n/10;
		  if(n>0)
			{
				re1=n%10;
				if(re!=re1)
					{
						flag=1;
						break;
					}
			}
		}	
		if(flag==1)
			System.out.println("all digits are  not equal");
		else
			System.out.println(" all digits are equal");		
				
	}
}
