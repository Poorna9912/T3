import java.util.*;
public class Trainee extends Person
{
	String Name,Course;
	int Age,Fee;
	Scanner s=new Scanner(System.in);
	Name=s.nextLine();
	Course=s.nextLine();
	Age=s.nextInt();
	Fee=s.nextInt();
	void display()
	{
		super.display();
		System.out.println("Course: "+Course+" fee: "+ Fee);
	}	
}
