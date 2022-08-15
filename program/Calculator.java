import java.util.*;
public class Calculator
{
	public static void main(String[] args) 
	{
		int Number1,Number2,Result=0;
		char c;
		System.out.println("enter 2 Numbers:");
		Scanner s=new Scanner(System.in);
		Number1=s.nextInt();
		Number2=s.nextInt();
		System.out.println("Enter an arithmatic operation");
		c=s.next().charAt(0);
		switch(c)
		{
			case '+':
					Result=Number1+Number2;
					break;
			case '-':
					Result=Number1-Number2;
					break;				
			case '*':
					Result=Number1*Number2;
					break;
			case '/':
					Result=Number1/Number2;
					break;
			case '%':
					Result=Number1%Number2;
					break;	
			default :			
					System.out.println(" the Expression not available");
		}
		
	System.out.println("The Result: "+Result);
	}
}
