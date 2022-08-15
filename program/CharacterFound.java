import java.util.*;
public class CharacterFound
{
	public static void main(String[] args) 
	{
		char c;
		System.out.println("enter a character:");
		Scanner s=new Scanner(System.in);
		c=s.next().charAt(0);
		
		System.out.println(c);
		if((c>='A')&&(c<='Z'))
			System.out.println(c+"is Upper Case");
		else if((c>='a')&&(c<='z'))
			System.out.println(c+"is Lower Case");	
		else if((c>='1')&&(c<='9'))
			System.out.println(c+"is Digits");
		else
			System.out.println(c+"is symbols");
	}
}
