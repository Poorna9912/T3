import java.util.*;
public class Average
{
	public static void main(String[] args)
	{
	        int size,i,j=1,av=0,min=0,max=0;
		Scanner s=new Scanner(System.in);
		System.out.println("Enter array size:");
		size=s.nextInt();
		int a[]=new int[size];
		System.out.println("enter values:");
		for(i=0;i<size;i++,j++)
		{
			a[i]=s.nextInt();
			av=av+a[i];
		}
		av=av/size;
		i=0;
		min=a[i];
		max=a[i];
		for(i=0;i<size-1;i++)
		{	
					if(max<a[i+1])
						max=a[i+1];
					if(min>a[i+1])
						min=a[i+1];
					
		}
		System.out.println("avg: "+av+" min: "+min+" max: "+max);
	}
}
