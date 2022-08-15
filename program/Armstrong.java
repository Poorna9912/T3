import java.util.*;
import java.lang.Math;
public class Armstrong
{
	public static void main(String []args)
	{
		int Number,Number1,re,s=0;
		Scanner sc=new Scanner(System.in);
		System.out.println("enter a number:");
		Number=sc.nextInt();
		Number1=Number;
		while(Number>0)
		{
			re=Number%10;
			Number=Number/10;
			s=s+(re*re*re);		
		}
		if(s == Number1)
			System.out.println(Number1+" number is Armstrong");
		else
			System.out.println(Number1+" number is not Armstrong");
	}
}
