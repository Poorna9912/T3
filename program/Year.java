import java.util.*;
public class Year
{
	public static void main(String[] args) 
	{
		int Year;
		System.out.println("enter a year:");
		Scanner s=new Scanner(System.in);
		Year=s.nextInt();
		if(((Year%4==0)&&(Year%100!=0))||(Year%400==0))
			System.out.println(Year+"is leap");
		else
			System.out.println(Year+"is not leap");	
	}
}
