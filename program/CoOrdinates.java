import java.util.*;
public class CoOrdinates
{
	public static void main(String[] args)
	{
		int x,y;
		Scanner s= new Scanner(System.in);
		System.out.println("enter x and y axis");
		x=s.nextInt();
		y=s.nextInt();
		if(x>0 && y>0)
			System.out.println(x+" "+y+" "+"first quard");	
		else if(x<0 && y>0)
			System.out.println(x+" "+y+" "+"sec quard");
		else if(x<0 && y<0)
			System.out.println(x+" "+y+" "+"third quard");	
		else if(x>0 && y<0)
			System.out.println(x+" "+y+" "+"fourth quard");
		else
			System.out.println(x+" "+y+" "+"origin");
	}
}
