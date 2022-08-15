import java.util.*;
public class Words
{
	public static void main(String[] args)
	{
		int n,n1,n2,b,a;
		Scanner s=new Scanner(System.in);
		System.out.println("enter a number");
		n=s.nextInt();
		n1=n;
		n2=n;
		b=n1%10;
		a=n2/10;
		String[] sd=new String[]{"Zero","one","two","three","four","five","six","seven","eight","nine"};
	String[] dd=new String[]{"","ten","eleven","twelve","thirteen","fourteen","fifteen","sixteen","seventeen","eighteen","nineteen"};
	String[] td=new String[]{"","","twenty","thirty","fourty","fifty","sixty","seventy","eighty","ninty"};	
		if(a==1)
			System.out.println(dd[b+1]);
		else if(b==0)
			System.out.println(td[a]);
		else
			System.out.println(td[a]+"-"+sd[b]);
		
	}
}
