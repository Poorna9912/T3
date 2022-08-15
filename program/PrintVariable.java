import java.util.*;
public class PrintVariable
{
	public static void main(String[] args) 
	{
		char c;
		System.out.println("enter a character:");
		Scanner s=new Scanner(System.in);
		c=s.next().charAt(0);
		System.out.println("enter a digit:");
		int Number=s.nextInt();
		System.out.println("The character:"+c);
		/*if(((c>='a')&&(c>='z'))||((c>='A')&&(c<='Z')))
		  System.out.println("The Character:"+c);
		if((Number>='1')&&(Number<='9'))
		   System.out.println("The Digit:"+Number);
		*/
		
		System.out.println("The Digit:"+Number);	
	}
}
