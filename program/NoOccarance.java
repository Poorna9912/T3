import java.util.*;
public class NoOccarance
{
	public static void main(String[] args)
	{
	        int re=0,n,d,i;
		Scanner s=new Scanner(System.in);
		int a[]=new int[]{0,0,0,0,0,0,0,0,0,0};
		/*for(i=0;i<a.legth;i++)
		{
		System.out.println(i);
		//System.out.print(a[i]+" ");
		}*/
		
		System.out.println("Enter number:");
		n=s.nextInt();
		System.out.println("enter a digit to found it occourance:");
		d=s.nextInt();	
		while(n>0)
		{
			re=n%10;
			if(re==0)
				a[0]=a[0]+1;
			else if(re==1)
				a[1]=a[1]+1;
			else if(re==2)
				a[2]=a[2]+1;
			else if(re==3)
				a[3]=a[3]+1;
			else if(re==4)
				a[4]=a[4]+1;
			else if(re==5)
				a[5]=a[5]+1;
			else if(re==6)
				a[6]=a[6]+1;
			else if(re==7)
				a[7]=a[7]+1;
			else if(re==8)
				a[8]=a[8]+1;
			else 
				a[9]=a[9]+1;
			n=n/10;
			
		}
		
		/*
			to print the number of occourance of individual digit
		for(i=0;i<10;i++)
		{
			if(a[i]<=1)
				System.out.println("the digit "+i+" occurs "+a[i]+" times");
			
		}*/
		System.out.println("the digit "+d+" occurs "+a[d]+" times");
	
	}
}
