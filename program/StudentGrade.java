import java.util.*;
public class StudentGrade
{
	public static void main(String[] args)
	{
		int Marks;
		System.out.println("Enter marks:");
		Scanner s=new Scanner(System.in);
		Marks=s.nextInt();
		if(Marks>40)
		{
			if((Marks>=40)&&(Marks<50))
				System.out.println("D Grade");
			else if((Marks>=50)&&(Marks<60))
				System.out.println("C Grade");
			else if((Marks>=60)&&(Marks<70))
				System.out.println("B Grade");
			else if((Marks>=70)&&(Marks<80))
				System.out.println("A Grade");
			else if((Marks>=80)&&(Marks<90))
				System.out.println("A Grade");		
			else
				System.out.println("A+ Grade");	
		}
		else 
			System.out.println("Failed");
	}
}
