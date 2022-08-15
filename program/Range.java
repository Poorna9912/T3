import java.util.*;
public class Range
{
	public static void main(String[] args)
	{
		int i=0,ra;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a range");
		ra=s.nextInt();
		/*
		if(ra<=1 || ra>=10)
			System.out.println(ra+" is validate");
		 else
		   	System.out.println(ra+" is not validate");	
		*/
		while(ra<10)
			{
				if(ra>0)
					System.out.println(ra+" is validate");
					i=1;
					break;
					
			}
		if(i==0 || ra<0)
			System.out.println(ra+" is not validate");	
	}
}
