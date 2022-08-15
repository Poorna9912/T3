import java.util.*;
public class Month
{
	public static void main(String[] args) 
	{
		String Month;
		System.out.println("enter Month in this format:");
		Scanner s=new Scanner(System.in);
		System.out.println("jan");
		System.out.println("feb");
		System.out.println("mar");
		System.out.println("apr");
		System.out.println("may");
		System.out.println("jun");
		System.out.println("jul");
		System.out.println("aug");
		System.out.println("sep");
		System.out.println("oct");
		System.out.println("nov");
		System.out.println("dec");
		Month=s.nextLine();
		switch(Month)
		{
			case "jan":
					System.out.println("31 Days");
					break;
			case "feb":
					System.out.println("28 Days");
					break;			
			case "mar":
					System.out.println("31 Days");
					break;
			case "apr":
					System.out.println("30 Days");
					break;
			case "may":
					System.out.println("31 Days");
					break;	
			case "jun":
					System.out.println("30 Days");
					break;	
				
			case "jul":	
					System.out.println("31 Days");
					break;					
			case "aug":	
					System.out.println("31 Days");
					break;	
			case "sep":	
					System.out.println("30 Days");
					break;	
			case "oct":	
					System.out.println("31 Days");
					break;	
			case "nov":	
					System.out.println("30 Days");
					break;	
			case "dec": 	
					System.out.println("31 Days");
					break;			
	  	}
		
	}
}
