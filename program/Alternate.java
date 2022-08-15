import java.util.*;
public class Alternate
{
	public static void main(String[] args)
	{
		int n,c=0,o=0,e=0,re=0;
		Scanner s= new Scanner(System.in);
		System.out.println(" enter a number:");
		n=s.nextInt();
		while(n>0)
		{
			re=n%10;
			n=n/10;
			c++;
			if(c%2==0)
			{
				e=e+re;
				//System.out.println(e);
			}
			else
			{	
				o=o+re;
				//System.out.println(o);
			}		
		}
		/*int su=e+o;
		System.out.println("the sumof alternate digits: "+su);*/
		System.out.println("the sum of even alternate digits: "+e);
		System.out.println("the sum of odd alternate digits: "+o);
	}
}
