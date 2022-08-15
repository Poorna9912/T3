import java.util.*;
public class Person
{
	 String Name;
	 int Age;
	 Scanner s=new Scanner(System.in)
	Name=s.nextLine();
	Age=s.nextInt();
	void display()
	{
		System.out.println("Name: "+Name+" Age: "+Age);
	} 
}
